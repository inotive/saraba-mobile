import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saraba_mobile/core/utils/role_access_helper.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/overview/project_overview_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/project_pengeluaran_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/progress/project_progress_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/rab/project_rab_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/project_request_view.dart';
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
        length: 5,
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
              builder: (context, state) {
                final detail = state.detail;
                final title = detail?.overview.namaProyek ?? projectTitle;
                final currentUser = Hive.box<User>('userBox').get('current_user');
                final isProjectFinished = detail != null
                    ? _isProjectFinished(detail.overview.status)
                    : false;
                final canManageProjectActions =
                    !isProjectFinished &&
                    hasFullMenuAccess(currentUser?.role ?? '');
                final canCreateRequest = !isProjectFinished;

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
                                canEdit: canManageProjectActions,
                              ),
                              ProjectPengeluaranView(
                                projectId: projectId,
                                canEdit: canManageProjectActions,
                              ),
                              ProjectRequestView(
                                projectId: projectId,
                                canEdit: canCreateRequest,
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
