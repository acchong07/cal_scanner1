import 'package:cal_scanner/features/calories/presentation/cubit/food_log_cubit.dart';
import 'package:cal_scanner/features/calories/presentation/cubit/food_log_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/daily_tracker.dart';
import '../widgets/meal_list.dart';
import '../widgets/alert_message_widget.dart';

class HomeScreen extends StatefulWidget {
  final Widget? child;
  const HomeScreen({super.key, this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's trackers",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                BlocBuilder<FoodLogCubit, FoodLogState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        // Tracker Section
                        DailyTracker(
                          calories: state.totalCalories,
                          protein: state.totalProtein,
                          carbs: state.totalCarbs,
                          fat: state.totalFat,
                        ),
                        SizedBox(height: 24),

                        // Inline Alert Section for Success or Error
                        if (state.successMessage != null || state.error != null)
                          AlertMessageWidget(
                            errorMessage: state.error,
                            successMessage: state.successMessage,
                            onClose: () =>
                                context.read<FoodLogCubit>().clearMessages(),
                          ),

                        // Meals Section
                        Text(
                          'Meals',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 16),
                        MealList(meals: state.meals),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<FoodLogCubit>().pickAndScanImage(),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
