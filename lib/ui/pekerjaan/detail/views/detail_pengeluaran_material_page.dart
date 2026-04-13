import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/pengeluaran_detail_response_model.dart';
import 'package:saraba_mobile/repository/model/project/pengeluaran_item_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';

class DetailPengeluaranMaterialPage extends StatelessWidget {
  final String projectId;
  final String pengeluaranId;
  final String categoryLabel;
  final bool canEdit;

  const DetailPengeluaranMaterialPage({
    super.key,
    required this.projectId,
    required this.pengeluaranId,
    required this.categoryLabel,
    required this.canEdit,
  });

  Future<void> _openOptions(
    BuildContext context,
    MaterialPengeluaranDraft draft,
  ) async {
    final action = await showModalBottomSheet<_PengeluaranMaterialAction>(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _PengeluaranMaterialOptionsSheet(),
    );

    if (!context.mounted || action == null) {
      return;
    }

    if (action == _PengeluaranMaterialAction.delete) {
      final shouldDelete = await _showDeleteConfirmation(context);
      if (shouldDelete != true || !context.mounted) {
        return;
      }

      context.read<PengeluaranDetailBloc>().add(
        DeletePengeluaran(projectId: projectId, pengeluaranId: pengeluaranId),
      );
      return;
    }

    final result = await Navigator.push<PengeluaranMaterialFlowResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPengeluaranPage(
          projectId: projectId,
          pengeluaranId: pengeluaranId,
          category: PengeluaranCategory.material,
          pageTitle: 'Edit Pengeluaran',
          initialDraft: draft,
          successResult: const PengeluaranMaterialFlowResult(
            title: 'Berhasil Menyimpan',
            message: 'Kamu berhasil memperbarui pengeluaran',
          ),
        ),
      ),
    );

    if (!context.mounted || result == null) {
      return;
    }

    Navigator.pop(context, result);
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengeluaran'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus pengeluaran ini?',
          ),
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
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openItemDetail(
    BuildContext context,
    MaterialExpenseItem item,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await PekerjaanService().fetchPengeluaranItemDetail(
      projectId: projectId,
      batchId: pengeluaranId,
      itemId: item.id,
    );

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) {
      return;
    }

    if (response?.success != true || response?.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?.message.isNotEmpty == true
                ? response!.message
                : 'Gagal memuat detail item pengeluaran',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MaterialItemDetailSheet(detail: response!.data!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PengeluaranDetailBloc(PekerjaanService())
        ..add(
          FetchPengeluaranDetail(
            projectId: projectId,
            pengeluaranId: pengeluaranId,
          ),
        ),
      child: BlocConsumer<PengeluaranDetailBloc, PengeluaranDetailState>(
        listener: (context, state) {
          if (state.deleteErrorMessage != null &&
              state.deleteErrorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.deleteErrorMessage!)));
          }

          if (state.deleteSuccessMessage != null &&
              state.deleteSuccessMessage!.isNotEmpty) {
            Navigator.pop(
              context,
              PengeluaranMaterialFlowResult(
                title: 'Berhasil Menghapus',
                message: state.deleteSuccessMessage!,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.detail == null) {
            return const Scaffold(
              backgroundColor: Color(0xFFFAFAFA),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.errorMessage != null && state.detail == null) {
            return Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PengeluaranDetailBloc>().add(
                              FetchPengeluaranDetail(
                                projectId: projectId,
                                pengeluaranId: pengeluaranId,
                              ),
                            );
                          },
                          child: const Text('Muat Ulang'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          final detail = state.detail;
          if (detail == null) {
            return const SizedBox.shrink();
          }

          final draft = _buildDraft(detail);

          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            body: SafeArea(
              child: Column(
                children: [
                  _DetailHeader(categoryLabel: categoryLabel),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _DetailLabel('ID'),
                          const SizedBox(height: 4),
                          _DetailValue(detail.id.toString()),
                          const SizedBox(height: 18),
                          const _DetailLabel('Nomor Transaksi'),
                          const SizedBox(height: 4),
                          _DetailValue(detail.nomorTransaksi),
                          const SizedBox(height: 18),
                          const _DetailLabel('Tanggal Transaksi'),
                          const SizedBox(height: 4),
                          _DetailValue(
                            DateFormat(
                              'dd MMMM yyyy',
                              'id_ID',
                            ).format(draft.date),
                          ),
                          const SizedBox(height: 18),
                          const _DetailLabel('Catatan'),
                          const SizedBox(height: 4),
                          _DetailValue(draft.note),
                          const SizedBox(height: 18),
                          const _DetailLabel('Lampiran'),
                          const SizedBox(height: 8),
                          if (draft.attachments.isEmpty)
                            const _EmptyAttachmentValue()
                          else
                            SizedBox(
                              height: 74,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: draft.attachments.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AttachmentThumbnail(
                                    image: draft.attachments[index],
                                    galleryImages: draft.attachments,
                                    initialIndex: index,
                                    width: 74,
                                    height: 74,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 18),
                          const _DetailLabel('Grand Total'),
                          const SizedBox(height: 4),
                          _DetailValue(_formatDetailCurrency(detail.grandTotal)),
                          const SizedBox(height: 18),
                          const Text(
                            'Item Material',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...draft.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _MaterialDetailItemCard(
                                item: item,
                                onTapDetail: () => _openItemDetail(context, item),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFF1F3F5))),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 14,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      children: [
                        if (canEdit)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: state.isDeleting
                                  ? null
                                  : () => _openOptions(context, draft),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFF7944D),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size.fromHeight(50),
                              ),
                              icon: state.isDeleting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFF7944D),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.more_horiz,
                                      color: Color(0xFFF7944D),
                                    ),
                              label: Text(
                                state.isDeleting ? 'Menghapus...' : 'Pilihan',
                                style: const TextStyle(
                                  color: Color(0xFFF7944D),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  MaterialPengeluaranDraft _buildDraft(PengeluaranDetailData detail) {
    return MaterialPengeluaranDraft(
      materialCode: detail.nomorTransaksi,
      date: _parseDetailDate(detail.tanggal),
      note: detail.catatan,
      attachments: detail.lampiran
          .map((item) => MaterialAttachmentItem.network(item.url))
          .toList(),
      items: detail.items
          .map(
            (item) => MaterialExpenseItem(
              id: item.id.toString(),
              name: item.namaItem,
              quantity: item.kuantitas,
              total: item.jumlah,
              isSelected: true,
            ),
          )
          .toList(),
    );
  }
}

DateTime _parseDetailDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'en_US').parseStrict(rawDate);
  } catch (_) {
    return DateTime.tryParse(rawDate) ?? DateTime.now();
  }
}

enum _PengeluaranMaterialAction { edit, delete }

class _PengeluaranMaterialOptionsSheet extends StatelessWidget {
  const _PengeluaranMaterialOptionsSheet();

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
            _OptionTile(
              icon: Icons.edit_outlined,
              label: 'Edit Pengeluaran',
              onTap: () =>
                  Navigator.pop(context, _PengeluaranMaterialAction.edit),
            ),
            _OptionTile(
              icon: Icons.delete_outline,
              label: 'Hapus Pengeluaran',
              color: const Color(0xFFFF5B5B),
              onTap: () =>
                  Navigator.pop(context, _PengeluaranMaterialAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
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

class _DetailHeader extends StatelessWidget {
  final String categoryLabel;

  const _DetailHeader({required this.categoryLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          Expanded(
            child: Text(
              'Detail Transaksi $categoryLabel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLabel extends StatelessWidget {
  final String text;

  const _DetailLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Color(0xFF7C8595)),
    );
  }
}

class _DetailValue extends StatelessWidget {
  final String text;

  const _DetailValue(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1B2A4A),
      ),
    );
  }
}

class _EmptyAttachmentValue extends StatelessWidget {
  const _EmptyAttachmentValue();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '-',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1B2A4A),
      ),
    );
  }
}

class _MaterialDetailItemCard extends StatelessWidget {
  final MaterialExpenseItem item;
  final VoidCallback onTapDetail;

  const _MaterialDetailItemCard({
    required this.item,
    required this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: Color(0xFF5D93E8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Material',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MaterialItemMeta(
                        label: 'Qty',
                        value: item.quantity.toString(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _MaterialItemMeta(
                        label: 'Total',
                        value: _formatDetailCurrency(item.total),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onTapDetail,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFF7944D)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text(
              'Lihat Detail',
              style: TextStyle(
                color: Color(0xFFF7944D),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialItemMeta extends StatelessWidget {
  final String label;
  final String value;

  const _MaterialItemMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

class _MaterialItemDetailSheet extends StatelessWidget {
  final PengeluaranItemDetailData detail;

  const _MaterialItemDetailSheet({required this.detail});

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
                    'Lihat Detail',
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
            _MaterialBottomRow(label: 'Nama Item', value: detail.namaItem),
            const SizedBox(height: 14),
            _MaterialBottomRow(
              label: 'Total',
              value: _formatDetailCurrency(detail.jumlah),
            ),
            const SizedBox(height: 14),
            _MaterialBottomRow(
              label: 'Qty',
              value: detail.kuantitas.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialBottomRow extends StatelessWidget {
  final String label;
  final String value;

  const _MaterialBottomRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

String _formatDetailCurrency(double value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}
