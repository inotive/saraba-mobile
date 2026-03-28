import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/project_detail_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_state.dart';
import 'package:saraba_mobile/ui/widgets/project_card.dart';

class PekerjaanPage extends StatefulWidget {
  const PekerjaanPage({super.key});

  @override
  State<PekerjaanPage> createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshProyeks() async {
    context.read<PekerjaanBloc>().add(FetchProyeks(page: 1));
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels < threshold) {
      return;
    }

    final state = context.read<PekerjaanBloc>().state;
    if (state.currentPage < state.lastPage && !state.isLoadingMore) {
      context.read<PekerjaanBloc>().add(
            FetchProyeks(page: state.currentPage + 1),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerSection(),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<PekerjaanBloc, PekerjaanState>(
            builder: (context, state) {
              if (state.isLoading && state.projects.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null && state.projects.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PekerjaanBloc>().add(FetchProyeks());
                        },
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                );
              }

              if (state.projects.isEmpty) {
                return const Center(child: Text('Belum ada data proyek'));
              }

              return _projectSection(context, state);
            },
          ),
        ),
      ],
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      child: const Text(
        "Pekerjaan",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _projectSection(BuildContext context, PekerjaanState state) {
    return RefreshIndicator(
      onRefresh: _refreshProyeks,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.projects.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= state.projects.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final item = state.projects[index];
            return ProjectCard(
              project: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailPage(
                      projectId: item.id,
                      projectTitle: item.title,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
