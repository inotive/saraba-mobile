import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class RadioRingWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const RadioRingWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neutral200),
          color: AppColors.whiteContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.body16SemiBold.copyWith(
                color: AppColors.neutral900,
              ),
            ),
            CustomRadioRing(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class CustomRadioRing extends StatelessWidget {
  final bool isSelected;
  final Color selectedColor;
  final double size;
  final double ringWidth;

  const CustomRadioRing({
    super.key,
    required this.isSelected,
    this.selectedColor = const Color(0xFF2F5DA9),
    this.size = 26,
    this.ringWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? selectedColor : AppColors.grey300,
          width: isSelected ? ringWidth : 2,
        ),
      ),
    );
  }
}
