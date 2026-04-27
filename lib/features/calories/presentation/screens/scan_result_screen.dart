import 'dart:io';
import 'package:cal_scanner/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/food_log_cubit.dart';
import '../cubit/food_log_state.dart';

class ScanResultScreen extends StatelessWidget {
  final File imageFile;
  const ScanResultScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodLogCubit, FoodLogState>(
      builder: (context, state) {
        final meal = state.scannedMeal;
        final isScanning = state.isScanning;

        return Scaffold(
          backgroundColor: AppColors.kScaffold,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar — hidden while scanning ──
                if (!isScanning)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          color: Colors.black54,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                // ── Food image — hidden while scanning ──
                if (!isScanning) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      imageFile,
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Loading state ──
                // ── Loading state ──
                if (isScanning) ...[
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF8C00),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Analyzing your food...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Identifying dish & estimating nutrition',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Error state ──
                ] else if (state.error != null) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Retake'),
                        ),
                      ],
                    ),
                  ),

                  // ── Meal result state ──
                ] else if (meal != null) ...[
                  // Meal name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.edit, size: 16, color: Colors.black45),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Calories
                  Text(
                    meal.calories.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8C00),
                      height: 1,
                    ),
                  ),
                  const Text(
                    'calories',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${meal.quantity.toStringAsFixed(0)}g',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  // Cooking style
                  const Text(
                    'Cooking Style',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CookingChip(
                        label: 'Light',
                        emoji: '🥗',
                        subtitle: 'Steamed, grilled, minimal oil',
                        selected: false,
                      ),
                      const SizedBox(width: 8),
                      _CookingChip(
                        label: 'Standard',
                        emoji: '🍳',
                        subtitle: 'Typical home-cooked',
                        selected: true,
                      ),
                      const SizedBox(width: 8),
                      _CookingChip(
                        label: 'Rich',
                        emoji: '🧈',
                        subtitle: 'Extra ghee, fried, restaurant',
                        selected: false,
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<FoodLogCubit>().clearMessages();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Log This Meal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8C00),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFFFF8C00),
                            ),
                            label: const Text(
                              'Retake',
                              style: TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 16,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFF8C00)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CookingChip extends StatelessWidget {
  final String label, emoji, subtitle;
  final bool selected;
  const _CookingChip({
    required this.label,
    required this.emoji,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFF8C00) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? const Color(0xFFFF8C00) : Colors.black12,
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: selected ? Colors.white70 : Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
