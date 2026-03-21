import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_foto_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_overview_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_pengeluaran_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_progress_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_rab_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_top_tab_bar.dart';

class ProjectDetailPage extends StatelessWidget {
  final ProjectModel projectModel;

  const ProjectDetailPage({super.key, required this.projectModel});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              DetailHeader(title: projectModel.title),
              const DetailTopTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    ProjectOverviewView(projectModel: projectModel),
                    ProjectRabView(),
                    ProjectProgressView(),
                    ProjectPengeluaranView(),
                    ProjectFotoView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
