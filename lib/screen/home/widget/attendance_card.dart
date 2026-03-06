import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "Don't miss your attendance today",
            style: AppStyles.body12Regular.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/calendar_icon.png',
                height: 16,
                width: 16,
              ),
              SizedBox(width: 4),
              Text(
                "22 July 2024",
                style: AppStyles.body14Medium.copyWith(
                  color: AppColors.black33,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "02:45:30",
                style: AppStyles.body14Medium.copyWith(
                  color: AppColors.black33,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.orangeContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Clock In',
                              style: AppStyles.body14Medium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: VerticalDivider(color: Colors.white),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Clock Out',
                              style: AppStyles.body14Medium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
