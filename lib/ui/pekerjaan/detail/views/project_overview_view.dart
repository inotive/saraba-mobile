import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';

class ProjectOverviewView extends StatelessWidget {
  final ProjectOverviewDetail overview;

  const ProjectOverviewView({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final progressValue = _normalizePercent(overview.progress);
    final budgetValue = _normalizePercent(overview.budgetPercent);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Progress Proyek",
              style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
            ),
            const SizedBox(height: 4),
            Text(
              "${(progressValue * 100).round()}%",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFF7944D)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _LabelValueColumn(
                    label: "Mulai",
                    value: _formatShortDate(overview.tanggalMulai),
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: _LabelValueColumn(
                    label: "Selesai",
                    value: _formatShortDate(overview.tanggalSelesai),
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _InfoRow(label: "Dinas", value: overview.dinas),
            const SizedBox(height: 8),
            _InfoRow(label: "Lokasi", value: overview.lokasi),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Nilai Proyek",
              value: _formatCurrency(overview.nilaiProyek),
            ),
            const SizedBox(height: 8),
            _StatusRow(label: "Status", value: _formatStatus(overview.status)),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _InfoRow(
              label: "Tanggal Mulai",
              value: _formatLongDate(overview.tanggalMulai),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Tanggal Berakhir",
              value: _formatLongDate(overview.tanggalSelesai),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Durasi Pekerjaan",
              value: "${overview.durasiHari} Hari",
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _InfoRow(
              label: "Estimasi Pengeluaran",
              value: _formatCurrency(overview.estimasiPengeluaran),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Pengeluaran Saat Ini",
              value: _formatCurrency(overview.nilaiPengeluaran),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Sisa Budget",
              value: _formatCurrency(overview.sisaBudget.toString()),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Text(
              "Budget Indicator Bar:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${(budgetValue * 100).round()}% Dari Estimasi",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _BudgetBar(progress: budgetValue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    );
  }
}

double _normalizePercent(double value) {
  if (value <= 1) {
    return value.clamp(0.0, 1.0);
  }

  return (value / 100).clamp(0.0, 1.0);
}

String _formatCurrency(String rawValue) {
  final parsedValue = double.tryParse(rawValue) ?? 0;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(parsedValue);
}

String _formatShortDate(String rawDate) {
  try {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

String _formatLongDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

String _formatStatus(String rawStatus) {
  if (rawStatus.isEmpty) {
    return '-';
  }

  return rawStatus[0].toUpperCase() + rawStatus.substring(1);
}

class _LabelValueColumn extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  const _LabelValueColumn({
    required this.label,
    required this.value,
    required this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1E2A4A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatusRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isActive = value.toLowerCase() == 'aktif';
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE6F7E9) : const Color(0xFFFFF4E5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFB26A00),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BudgetBar extends StatelessWidget {
  final double progress;

  const _BudgetBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: const Color(0xFFE5E7EB),
        valueColor: const AlwaysStoppedAnimation(Color(0xFF6B8AF7)),
      ),
    );
  }
}
