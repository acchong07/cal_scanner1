import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeightWidget extends StatelessWidget {
  const HeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          context.read<OnboardingCubit>().updateHeight(parsed);
        }
      },
      decoration: InputDecoration(labelText: 'Height in cm'),
    );
  }
}
