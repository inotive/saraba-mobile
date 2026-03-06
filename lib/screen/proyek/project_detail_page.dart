import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';
import 'package:saraba_mobile/screen/proyek/tab/overview_tab.dart';
import 'package:saraba_mobile/screen/proyek/tab/progress_tab.dart';

class ProjectDetailPage extends StatelessWidget {
  final String title;

  const ProjectDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        appBar: AppBar(
          title: Text(
            title,
            style: AppStyles.body20Bold.copyWith(color: AppColors.neutral900),
          ),
          bottom: TabBar(
            labelColor: AppColors.neutral900,
            unselectedLabelColor: AppColors.neutral500,
            indicatorColor: AppColors.indicatorTabbarColor,
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Progress"),
              Tab(text: "Keuangan"),
              Tab(text: "Foto"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            OverviewTab(),
            ProgressTab(),
            Center(child: Text("Keuangan Page")),
            Center(child: Text("Foto Page")),
          ],
        ),
      ),
    );
  }
}
