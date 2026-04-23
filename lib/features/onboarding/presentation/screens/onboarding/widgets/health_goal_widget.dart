import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/onboarding_cubit.dart';
import '../../../cubit/onboarding_state.dart';

class HealthGoalWidget extends StatelessWidget {
  const HealthGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.userGoal,
          isExpanded: true,
          hint: Text('Select Your Goal'),
          items: [
            'Weight Loss',
            'Maintenance',
            'Muscle Gain',
          ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<OnboardingCubit>().updateGoal(value);
            }
          },
        );
      },
    );
  }
}
