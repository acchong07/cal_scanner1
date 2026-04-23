import 'package:cal_scanner/core/extensions/num_extension.dart';
import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:cal_scanner/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/onboarding_state.dart';

class GenderWidget extends StatelessWidget {
  const GenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your\n biological sex',
          style: AppTypography.headlineLarge,
        ),
        10.kH,

        Text(
          'This helps us calculate your metabolism',
          style: AppTypography.bodyMedium,
        ),

        BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return DropdownButton<String>(
              value: state.gender,
              isExpanded: true,
              hint: Text('Select Your Gender'),
              items: [
                'Male',
                'Female',
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<OnboardingCubit>().updateGender(value);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
