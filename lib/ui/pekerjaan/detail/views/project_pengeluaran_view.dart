import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/detail_pengeluaran_material_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/detail_pengeluaran_operasional_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/pengeluaran_item_card.dart';

class ProjectPengeluaranView extends StatelessWidget {
  final String projectId;
  final ProjectPengeluaranSection pengeluaran;
  final bool canEdit;

  const ProjectPengeluaranView({
    super.key,
    required this.projectId,
    required this.pengeluaran,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final groupedData = <String, List<ProjectPengeluaranItem>>{};
    for (final item in pengeluaran.items) {
      groupedData.putIfAbsent(item.tanggal, () => []).add(item);
    }
    final dates = groupedData.keys.toList();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, canEdit ? 80 : 16),
          child: pengeluaran.items.isEmpty
              ? const _EmptyPengeluaranState()
              : ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final items = groupedData[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/ic_pengeluaran_calendar.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatLongDate(date),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                          child: PengeluaranItemCard(
                              code: _buildCardCode(item),
                              title: _buildCardTitle(item.kategori),
                              tanggal: _formatShortDate(item.tanggal),
                              summaryLabel: _buildPrimaryLabel(),
                              summaryValue: _buildPrimaryValue(pengeluaran),
                              secondaryLabel: _buildSecondaryLabel(),
                              secondaryValue: _buildSecondaryValue(
                                pengeluaran,
                              ),
                              iconAsset: _buildCardIconAsset(item.kategori),
                              onTap: _buildOnTap(
                                context,
                                projectId,
                                item,
                                canEdit,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
        ),

        if (canEdit)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<PengeluaranCategory>(
                    context: context,
                    backgroundColor: const Color(0xFFFAFAFA),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => const PengeluaranCategorySheet(),
                  ).then((category) async {
                    if (!context.mounted || category == null) {
                      return;
                    }

                    final result =
                        await Navigator.push<PengeluaranMaterialFlowResult>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TambahPengeluaranPage(
                              projectId: projectId,
                              category: category,
                            ),
                          ),
                        );

                    if (!context.mounted || result == null) {
                      return;
                    }

                    context.read<ProjectDetailBloc>().add(
                      FetchProjectDetail(projectId),
                    );
                    StatusBanner.show(
                      context,
                      title: result.title,
                      message: result.message,
                      type: StatusBannerType.success,
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7944D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Tambah Pengeluaran",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _buildCardCode(ProjectPengeluaranItem item) {
  final kategori = item.kategori;
  final normalized = kategori.toLowerCase();
  if (normalized.contains('material')) {
    return 'MAT-${item.id}';
  }
  if (normalized.contains('petty')) {
    return 'PC-${item.id}';
  }
  return 'OPR-${item.id}';
}

String _buildCardTitle(String kategori) {
  final normalized = kategori.toLowerCase();
  if (normalized.contains('material')) {
    return 'Material';
  }
  if (normalized.contains('petty')) {
    return 'Petty Cash';
  }
  return 'Operasional';
}

String _buildCardIconAsset(String kategori) {
  final normalized = kategori.toLowerCase();
  if (normalized.contains('material')) {
    return 'assets/icons/ic_pengeluaran_material.png';
  }
  if (normalized.contains('petty')) {
    return 'assets/icons/ic_pengeluaran_petty_cash.png';
  }
  return 'assets/icons/ic_pengeluaran_operasional.png';
}

String _buildPrimaryLabel() {
  return 'Total Item';
}

String _buildPrimaryValue(ProjectPengeluaranSection pengeluaran) {
  return '${pengeluaran.items.length}';
}

String _buildSecondaryLabel() {
  return 'Jumlah Biaya';
}

String _buildSecondaryValue(ProjectPengeluaranSection pengeluaran) {
  return _formatCurrency(pengeluaran.totalPengeluaran.toString());
}

Future<void> Function()? _buildOnTap(
  BuildContext context,
  String projectId,
  ProjectPengeluaranItem item,
  bool canEdit,
) {
  final category = item.kategori.toLowerCase();

  if (category.contains('material')) {
    return () async {
      final result = await Navigator.push<PengeluaranMaterialFlowResult>(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPengeluaranMaterialPage(
            projectId: projectId,
            pengeluaranId: item.id.toString(),
            categoryLabel: item.kategoriLabel.isNotEmpty
                ? item.kategoriLabel
                : _buildCardTitle(item.kategori),
            canEdit: canEdit,
          ),
        ),
      );

      if (!context.mounted || result == null) {
        return;
      }

      context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));
      StatusBanner.show(
        context,
        title: result.title,
        message: result.message,
        type: StatusBannerType.success,
      );
    };
  }

  if (category.contains('operasional')) {
    return () async {
      final result = await Navigator.push<PengeluaranMaterialFlowResult>(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPengeluaranOperasionalPage(
            projectId: projectId,
            pengeluaranId: item.id.toString(),
            category: PengeluaranCategory.operasional,
            canEdit: canEdit,
          ),
        ),
      );

      if (!context.mounted || result == null) {
        return;
      }

      context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));
      StatusBanner.show(
        context,
        title: result.title,
        message: result.message,
        type: StatusBannerType.success,
      );
    };
  }

  if (category.contains('petty')) {
    return () async {
      final result = await Navigator.push<PengeluaranMaterialFlowResult>(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPengeluaranOperasionalPage(
            projectId: projectId,
            pengeluaranId: item.id.toString(),
            category: PengeluaranCategory.pettyCash,
            canEdit: canEdit,
          ),
        ),
      );

      if (!context.mounted || result == null) {
        return;
      }

      context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));
      StatusBanner.show(
        context,
        title: result.title,
        message: result.message,
        type: StatusBannerType.success,
      );
    };
  }

  return null;
}

String _formatCurrency(String rawValue) {
  final parsedValue = double.tryParse(rawValue) ?? 0;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(parsedValue);
}

String _formatLongDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

String _formatShortDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

class _EmptyPengeluaranState extends StatelessWidget {
  const _EmptyPengeluaranState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Belum ada pengeluaran untuk ditampilkan',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
