import 'dart:io';

import 'package:cal_scanner/features/calories/presentation/cubit/food_log_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/food_item.dart';
import '../../data/repositories/food_repository.dart';

class FoodLogCubit extends Cubit<FoodLogState> {
  final FoodRepository _repository;
  final ImagePicker _picker;
  FoodLogCubit(this._repository, [ImagePicker? picker])
    : _picker = picker ?? ImagePicker(),
      super(FoodLogState());

  Future<void> pickAndScanImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final image = File(pickedFile.path);
    emit(state.copyWith(selectedImage: image));
    await addMealFromImage(image);
  }

  Future<void> loadDailyLog() async {
    emit(state.copyWith(isLoading: true));
    try {
      final meals = await _repository.getDailyFoodLog(DateTime.now());
      final totals = _calculateTotals(meals);
      final weeklyData = await _loadWeeklyData();

      emit(
        state.copyWith(
          meals: meals,
          totalCalories: totals['calories'],
          totalProtein: totals['protein'],
          totalCarbs: totals['carbs'],
          totalFat: totals['fat'],
          weeklyData: weeklyData,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> addMeal(FoodItem meal) async {
    try {
      await _repository.addFoodItem(meal);
      await loadDailyLog();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Map<String, double> _calculateTotals(List<FoodItem> meals) {
    return meals.fold(
      {'calories': 0.0, 'protein': 0.0, 'carbs': 0.0, 'fat': 0.0},
      (totals, meal) {
        totals['calories'] = (totals['calories'] ?? 0) + meal.calories;
        totals['protein'] = (totals['protein'] ?? 0) + meal.protein;
        totals['carbs'] = (totals['carbs'] ?? 0) + meal.carbs;
        totals['fat'] = (totals['fat'] ?? 0) + meal.fat;
        return totals;
      },
    );
  }

  Future<List<double>> _loadWeeklyData() async {
    final List<double> weeklyData = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final meals = await _repository.getDailyFoodLog(date);
      final calories = meals.fold(0.0, (sum, meal) => sum + meal.calories);
      weeklyData.add(calories);
    }

    return weeklyData;
  }

  Future<void> addMealFromImage(File image) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.detectFoodFromImage(image);
    result.fold(
      (failure) {
        // Emit error message
        emit(
          state.copyWith(
            error: failure,
            successMessage: null,
            isLoading: false,
          ),
        );
      },
      (meal) async {
        await addMeal(meal);
        // Emit success message
        emit(
          state.copyWith(
            error: null,
            successMessage:
                'Food "${meal.name}" detected successfully and added to the log.',
            isLoading: false,
          ),
        );
      },
    );
  }

  void clearMessages() {
    emit(
      FoodLogState(
        meals: state.meals,
        totalCalories: state.totalCalories,
        totalProtein: state.totalProtein,
        totalCarbs: state.totalCarbs,
        totalFat: state.totalFat,
        weeklyData: state.weeklyData,
        isLoading: state.isLoading,
        error: null, // Explicitly clear error
        successMessage: null, // Explicitly clear success message
      ),
    );
  }

  Future<void> deleteMeal(FoodItem meal) async {
    try {
      await _repository.deleteFoodItem(meal);
      await loadDailyLog();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateMeal(FoodItem meal) async {
    try {
      await _repository.updateFoodItem(meal);
      await loadDailyLog();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
