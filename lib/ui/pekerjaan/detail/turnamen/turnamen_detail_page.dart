import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/bloc/turnamen_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/bloc/turnamen_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/bloc/turnamen_detail_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/views/turnamen_overview_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/views/turnamen_pemain_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/views/turnamen_pengeluaran_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/detail_top_tab_bar.dart';

/// Detail turnamen (Sport Station), hanya baca: Overview, Pemain, Pengeluaran.
class TurnamenDetailPage extends StatelessWidget {
  final String turnamenId;
  final String turnamenTitle;

  const TurnamenDetailPage({
    super.key,
    required this.turnamenId,
    required this.turnamenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TurnamenDetailBloc(PekerjaanService())
            ..add(FetchTurnamenDetail(turnamenId)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: BlocBuilder<TurnamenDetailBloc, TurnamenDetailState>(
              builder: (context, state) {
                final detail = state.detail;
                final title = detail?.overview.namaTurnamen ?? turnamenTitle;

                return Column(
                  children: [
                    DetailHeader(title: title),
                    const DetailTopTabBar(
                      tabs: ['Overview', 'Pemain', 'Pengeluaran'],
                    ),
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
                                        context.read<TurnamenDetailBloc>().add(
                                          FetchTurnamenDetail(turnamenId),
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

                          Future<void> refresh() async {
                            final bloc = context.read<TurnamenDetailBloc>();
                            bloc.add(FetchTurnamenDetail(turnamenId));
                            await bloc.stream.firstWhere((s) => !s.isLoading);
                          }

                          return TabBarView(
                            children: [
                              TurnamenOverviewView(
                                overview: detail.overview,
                                onRefresh: refresh,
                              ),
                              TurnamenPemainView(
                                pemain: detail.pemain,
                                onRefresh: refresh,
                              ),
                              TurnamenPengeluaranView(
                                pengeluaran: detail.pengeluaran,
                                onRefresh: refresh,
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
