import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:saraba_mobile/screen/proyek/input_expense_page.dart';
import 'package:saraba_mobile/screen/proyek/project_detail_page.dart';
import 'widget/project_card.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proyek Anda',
            style: AppStyles.body18SemiBold.copyWith(color: AppColors.black33),
          ),
          SizedBox(height: 16),
          ProjectCard(
            title: 'Proyek A',
            percent: 0.6,
            value: 500000,
            expense: 120000,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProjectDetailPage(title: 'Proyek A'),
                ),
              );
            },
          ),
          ProjectCard(
            title: 'Proyek B',
            percent: 0.3,
            value: 500000,
            expense: 120000,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InputExpensePage()),
              );
            },
          ),
          ProjectCard(
            title: 'Proyek C',
            percent: 1.0,
            value: 500000,
            expense: 120000,
          ),
        ],
      ),
    );
  }
}
