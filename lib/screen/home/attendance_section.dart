import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'widget/attendance_card.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.lightBlueHomepage),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 50,
                  child: Text(''),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo Biko 👋",
                      style: AppStyles.body24SemiBold.copyWith(
                        color: AppColors.black33,
                      ),
                    ),
                    Text(
                      "Senior Accountant",
                      style: AppStyles.body14Regular.copyWith(
                        color: AppColors.black33,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const AttendanceCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
