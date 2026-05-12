import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:saraba_mobile/screen/home/attendance_section.dart';
import 'package:saraba_mobile/screen/home/project_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AttendanceSection(),
              SizedBox(height: 20),
              ProjectSection(),
            ],
          ),
        ),
      ),
    );
  }
}
