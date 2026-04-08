import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_overview_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_pengeluaran_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_progress_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/project_rab_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_top_tab_bar.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectDetailBloc(PekerjaanService())
            ..add(FetchProjectDetail(projectId)),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
              builder: (context, state) {
                final detail = state.detail;
                final title = detail?.overview.namaProyek ?? projectTitle;

                return Column(
                  children: [
                    DetailHeader(title: title),
                    const DetailTopTabBar(),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state.isLoading && detail == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.errorMessage != null && detail == null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.errorMessage!,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<ProjectDetailBloc>().add(
                                          FetchProjectDetail(projectId),
                                        );
                                      },
                                      child: const Text('Muat Ulang'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (detail == null) {
                            return const SizedBox.shrink();
                          }

                          return TabBarView(
                            children: [
                              ProjectOverviewView(overview: detail.overview),
                              ProjectRabView(rab: detail.rab),
                              ProjectProgressView(
                                overview: detail.overview,
                                progress: detail.progress,
                                canEdit: !_isProjectFinished(detail.overview.status),
                              ),
                              ProjectPengeluaranView(
                                projectId: projectId,
                                pengeluaran: detail.pengeluaran,
                                canEdit:
                                    !_isProjectFinished(detail.overview.status),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

bool _isProjectFinished(String status) {
  return status.trim().toLowerCase() == 'selesai';
}
