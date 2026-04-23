import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({super.key});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  final Map<String, String> activityLevelDescriptions = {
    'Sedentary': 'Little or no exercise, desk job',
    'Light': '1-3 days/week of exercise',
    'Moderate': '3-5 days/week of moderate activity',
    'Active': '6-7 days/week of exercise',
    'Very Active': 'Very intense exercise/sports & physical job',
  };
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.activityLevel,
          isExpanded: true,
          items: activityLevelDescriptions.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<OnboardingCubit>().updateActivityLevel(value);
            }
          },
          hint: Text('Select Activity Level'),
        );
      },
    );
  }
}
