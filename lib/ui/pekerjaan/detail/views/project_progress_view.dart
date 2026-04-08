import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
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
                            onTapArrow: canEdit
                                ? () => _openProgressOptions(
                                    context,
                                    overview.id.toString(),
                                    item,
                                  )
                                : null,
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

Future<void> _openProgressOptions(
  BuildContext context,
  String projectId,
  ProjectProgressLog log,
) async {
  final action = await showModalBottomSheet<_ProgressAction>(
    context: context,
    backgroundColor: const Color(0xFFFAFAFA),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _ProgressOptionsSheet(),
  );

  if (!context.mounted || action == null) {
    return;
  }

  if (action == _ProgressAction.edit) {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahProgressPage(
          projectId: projectId,
          pageTitle: 'Edit Progress',
          initialLog: log,
        ),
      ),
    );

    if (!context.mounted || result == null || result.isEmpty) {
      return;
    }

    context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));
    StatusBanner.show(
      context,
      title: 'Progress Berhasil',
      message: result,
      type: StatusBannerType.success,
    );
    return;
  }

  final shouldDelete = await _showDeleteConfirmation(context);
  if (!context.mounted || shouldDelete != true) {
    return;
  }

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final result = await PekerjaanService().deleteProgressLog(
    projectId: projectId,
    logId: log.id.toString(),
  );

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  if (!context.mounted) {
    return;
  }

  if (result?.success == true) {
    context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));
    StatusBanner.show(
      context,
      title: 'Progress Berhasil',
      message: result?.message.isNotEmpty == true
          ? result!.message
          : 'Progress berhasil dihapus',
      type: StatusBannerType.success,
    );
    return;
  }

  StatusBanner.show(
    context,
    title: 'Progress Gagal',
    message: result?.message.isNotEmpty == true
        ? result!.message
        : 'Gagal menghapus progress',
    type: StatusBannerType.error,
  );
}

Future<bool?> _showDeleteConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Hapus Progress'),
        content: const Text('Apakah kamu yakin ingin menghapus progress ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC52222),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

enum _ProgressAction { edit, delete }

class _ProgressOptionsSheet extends StatelessWidget {
  const _ProgressOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilihan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _ProgressOptionRow(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: () => Navigator.pop(context, _ProgressAction.edit),
            ),
            _ProgressOptionRow(
              icon: Icons.delete_outline,
              label: 'Hapus Progress',
              color: const Color(0xFFFF5B5B),
              onTap: () => Navigator.pop(context, _ProgressAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressOptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ProgressOptionRow({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF1F1F1F),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
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
