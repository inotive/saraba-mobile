import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/pengeluaran_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';

class DetailPengeluaranOperasionalPage extends StatelessWidget {
  final String projectId;
  final String pengeluaranId;
  final PengeluaranCategory category;
  final bool canEdit;

  const DetailPengeluaranOperasionalPage({
    super.key,
    required this.projectId,
    required this.pengeluaranId,
    required this.category,
    required this.canEdit,
  });

  Future<void> _openOptions(
    BuildContext context,
    OperasionalPengeluaranDraft draft,
  ) async {
    final action = await showModalBottomSheet<_OperasionalDetailAction>(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _OperasionalDetailOptionsSheet(),
    );

    if (!context.mounted || action == null) {
      return;
    }

    if (action == _OperasionalDetailAction.delete) {
      final shouldDelete = await _showDeleteConfirmation(context);
      if (shouldDelete != true || !context.mounted) {
        return;
      }

      context.read<PengeluaranDetailBloc>().add(
        DeletePengeluaran(
          projectId: projectId,
          pengeluaranId: pengeluaranId,
        ),
      );
      return;
    }

    final result = await Navigator.push<PengeluaranMaterialFlowResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPengeluaranPage(
          category: draft.category,
          pageTitle: 'Edit Pengeluaran',
          initialOperasionalDraft: draft,
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

  Future<void> _openItemDetail(
    BuildContext context,
    OperasionalExpenseItem item,
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

    final detail = response!.data!;
    final attachments = detail.lampiran
        .map((item) => MaterialAttachmentItem.network(item.url))
        .toList();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => OperasionalDetailSheet(
        note: detail.keterangan,
        attachments: attachments,
        amount: category == PengeluaranCategory.operasional
            ? _formatOperasionalCurrency(detail.jumlah)
            : null,
        totalItems: category == PengeluaranCategory.operasional
            ? detail.batch.totalItems.toString()
            : null,
      ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.deleteErrorMessage!)),
            );
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
          final grandTotal = draft.items.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );
          final categoryLabel = draft.category.label;

          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            body: SafeArea(
              child: Column(
                children: [
                  _DetailOperasionalHeader(categoryLabel: categoryLabel),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const _DetailLabel('Dibuat Oleh'),
                          const SizedBox(height: 4),
                          _DetailValue(draft.createdBy),
                          const SizedBox(height: 24),
                          Text(
                            'Item $categoryLabel',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...draft.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OperasionalExpenseCard(
                                item: item,
                                onTapDetail: () => _openItemDetail(context, item),
                                onTapEdit: canEdit
                                    ? () =>
                                          _openOptions(
                                            context,
                                            draft,
                                          )
                                    : null,
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
                      border: Border(
                        top: BorderSide(color: Color(0xFFF1F3F5)),
                      ),
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
                        Row(
                          children: [
                            const Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatOperasionalCurrency(grandTotal),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF7944D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (canEdit)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => state.isDeleting
                                  ? null
                                  : _openOptions(context, draft),
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

  OperasionalPengeluaranDraft _buildDraft(PengeluaranDetailData detail) {
    final attachmentItems = detail.lampiran
        .map((item) => MaterialAttachmentItem.network(item.url))
        .toList();

    return OperasionalPengeluaranDraft(
      category: category,
      operasionalName: detail.items.isNotEmpty
          ? detail.items.first.namaItem
          : detail.nomorTransaksi,
      date: _parseOperasionalDetailDate(detail.tanggal),
      createdBy: detail.user.name,
      items: detail.items
          .map(
            (item) => OperasionalExpenseItem(
              id: item.id.toString(),
              amount: item.jumlah,
              note: detail.catatan,
              attachments: attachmentItems,
            ),
          )
          .toList(),
    );
  }
}

DateTime _parseOperasionalDetailDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'en_US').parseStrict(rawDate);
  } catch (_) {
    return DateTime.tryParse(rawDate) ?? DateTime.now();
  }
}

enum _OperasionalDetailAction { edit, delete }

class _OperasionalDetailOptionsSheet extends StatelessWidget {
  const _OperasionalDetailOptionsSheet();

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
            _DetailOptionRow(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: () => Navigator.pop(context, _OperasionalDetailAction.edit),
            ),
            _DetailOptionRow(
              icon: Icons.delete_outline,
              label: 'Hapus Pengeluaran',
              color: const Color(0xFFFF5B5B),
              onTap: () =>
                  Navigator.pop(context, _OperasionalDetailAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailOptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DetailOptionRow({
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

class _DetailOperasionalHeader extends StatelessWidget {
  final String categoryLabel;

  const _DetailOperasionalHeader({required this.categoryLabel});

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

String _formatOperasionalCurrency(double value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}
