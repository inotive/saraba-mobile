import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final double percent;
  final double value;
  final double expense;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.percent,
    required this.value,
    required this.expense,
    this.onTap,
  });

  String formatCurrency(double number) {
    final format = NumberFormat('#,###', 'id_ID');
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.body16Bold.copyWith(color: AppColors.neutral900),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(percent * 100).toInt()}%",
                style: AppStyles.body12SemiBold.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: AppColors.neutral200,
              color: AppColors.primary300,
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nilai:',
                          style: AppStyles.body12Regular.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${formatCurrency(value)}',
                          style: AppStyles.body12Medium.copyWith(
                            color: AppColors.neutral800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengeluaran:',
                          style: AppStyles.body12Regular.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${formatCurrency(expense)}',
                          style: AppStyles.body12Medium.copyWith(
                            color: AppColors.neutral800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
