import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';

class DetailPengeluaranOperasionalPage extends StatelessWidget {
  final OperasionalPengeluaranDraft draft;

  const DetailPengeluaranOperasionalPage({super.key, required this.draft});

  Future<void> _openOptions(BuildContext context) async {
    final action = await showModalBottomSheet<_OperasionalDetailAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _OperasionalDetailOptionsSheet(),
    );

    if (!context.mounted || action == null) {
      return;
    }

    if (action == _OperasionalDetailAction.delete) {
      Navigator.pop(
        context,
        const PengeluaranMaterialFlowResult(
          title: 'Berhasil Menghapus',
          message: 'Pengeluaran berhasil dihapus',
        ),
      );
      return;
    }

    if (action == _OperasionalDetailAction.viewNote) {
      final note = draft.items.isNotEmpty ? draft.items.first.note : '-';
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => _DetailOperasionalNoteSheet(note: note),
      );
      return;
    }

    final result = await Navigator.push<PengeluaranMaterialFlowResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPengeluaranPage(
          category: PengeluaranCategory.operasional,
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

  @override
  Widget build(BuildContext context) {
    final grandTotal = draft.items.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const _DetailOperasionalHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DetailLabel('Nama Operasional'),
                    const SizedBox(height: 4),
                    _DetailValue(draft.operasionalName),
                    const SizedBox(height: 18),
                    const _DetailLabel('Tanggal Pengeluaran'),
                    const SizedBox(height: 4),
                    _DetailValue(
                      DateFormat('dd MMMM yyyy', 'id_ID').format(draft.date),
                    ),
                    const SizedBox(height: 18),
                    const _DetailLabel('Dibuat Oleh'),
                    const SizedBox(height: 4),
                    _DetailValue(draft.createdBy),
                    const SizedBox(height: 24),
                    const Text(
                      'Item Operasional',
                      style: TextStyle(
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
                          onTapOptions: () {},
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
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openOptions(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF7944D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Color(0xFFF7944D),
                      ),
                      label: const Text(
                        'Pilihan',
                        style: TextStyle(
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
  }
}

enum _OperasionalDetailAction { edit, viewNote, delete }

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
              icon: Icons.remove_red_eye_outlined,
              label: 'Lihat Catatan',
              onTap: () =>
                  Navigator.pop(context, _OperasionalDetailAction.viewNote),
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
  const _DetailOperasionalHeader();

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
          const Expanded(
            child: Text(
              'Detail Pengeluaran Operasional',
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

class _DetailOperasionalNoteSheet extends StatelessWidget {
  final String note;

  const _DetailOperasionalNoteSheet({required this.note});

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
                    'Lihat Catatan',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                note.trim().isEmpty ? '-' : note,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ],
        ),
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
