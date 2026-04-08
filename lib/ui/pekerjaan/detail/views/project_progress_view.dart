import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/progress_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_progress_page.dart';

class ProjectProgressView extends StatelessWidget {
  final ProjectOverviewDetail overview;
  final ProjectProgressSection progress;
  final bool canEdit;

  const ProjectProgressView({
    super.key,
    required this.overview,
    required this.progress,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, canEdit ? 92 : 16),
          child: Column(
            children: [
              _DateFilterField(value: _formatLongDate(DateTime.now())),
              const SizedBox(height: 12),
              _ProjectDateSummaryCard(
                mulaiProyek: _formatLongDateFromRaw(overview.tanggalMulai),
                selesai: _formatLongDateFromRaw(overview.tanggalSelesai),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: progress.logs.isEmpty
                    ? const _EmptyProgressState()
                    : ListView.separated(
                        itemCount: progress.logs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = progress.logs[index];
                          final progressValue = _normalizeProgress(
                            item.progressPersen,
                          );

                          return ProgressItemCard(
                            title: item.judul,
                            primaryLabel: 'Dibuat Oleh',
                            primaryValue: item.user.name,
                            secondaryLabel: 'Tanggal',
                            secondaryValue: _formatShortDate(item.tanggal),
                            persentase: '${(progressValue * 100).round()}%',
                            progress: progressValue,
                            images: item.fotos,
                            description: item.catatan,
                            onTapArrow: () {},
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        if (canEdit)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TambahProgressPage(
                        projectId: overview.id.toString(),
                      ),
                    ),
                  ).then((message) {
                    if (!context.mounted ||
                        message == null ||
                        message.isEmpty) {
                      return;
                    }

                    context.read<ProjectDetailBloc>().add(
                      FetchProjectDetail(overview.id.toString()),
                    );

                    StatusBanner.show(
                      context,
                      title: 'Progress Berhasil',
                      message: message,
                      type: StatusBannerType.success,
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7944D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Tambah Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

double _normalizeProgress(String rawValue) {
  final parsedValue = double.tryParse(rawValue) ?? 0;
  if (parsedValue <= 1) {
    return parsedValue.clamp(0.0, 1.0);
  }

  return (parsedValue / 100).clamp(0.0, 1.0);
}

String _formatLongDate(DateTime date) {
  return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
}

String _formatLongDateFromRaw(String rawDate) {
  try {
    return _formatLongDate(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

String _formatShortDate(String rawDate) {
  try {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

class _DateFilterField extends StatelessWidget {
  final String value;

  const _DateFilterField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
      ),
    );
  }
}

class _ProjectDateSummaryCard extends StatelessWidget {
  final String mulaiProyek;
  final String selesai;

  const _ProjectDateSummaryCard({
    required this.mulaiProyek,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _row("Mulai Proyek", mulaiProyek),
          const SizedBox(height: 10),
          _row("Selesai", selesai),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B2A4A),
          ),
        ),
      ],
    );
  }
}

class _EmptyProgressState extends StatelessWidget {
  const _EmptyProgressState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Belum ada progress untuk ditampilkan',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
