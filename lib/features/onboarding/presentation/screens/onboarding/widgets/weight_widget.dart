import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:cal_scanner/imports/packages_imports.dart';
import 'package:flutter/material.dart';

class WeightWidget extends StatelessWidget {
  const WeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          context.read<OnboardingCubit>().updateWeight(parsed);
        }
      },
      decoration: InputDecoration(labelText: 'Weight in kg'),
    );
  }
}
