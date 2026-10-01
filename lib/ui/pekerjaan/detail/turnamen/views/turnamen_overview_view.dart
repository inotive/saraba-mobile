import 'package:flutter/material.dart';
import 'package:saraba_mobile/core/utils/format_utils.dart';
import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';

class TurnamenOverviewView extends StatelessWidget {
  final TurnamenOverview overview;
  final Future<void> Function() onRefresh;

  const TurnamenOverviewView({
    super.key,
    required this.overview,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final keterangan = overview.keterangan.trim();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Pengeluaran",
                style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(overview.totalPengeluaran),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7944D),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _InfoRow(
                label: "Tanggal Turnamen",
                value: formatLongDate(overview.tanggalMulai),
              ),
              const SizedBox(height: 8),
              _InfoRow(label: "Tempat / Stadion", value: overview.lapangan),
              const SizedBox(height: 8),
              _InfoRow(
                label: "Jumlah Pemain",
                value: "${overview.totalPemain} orang",
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              const Text(
                "Deskripsi Turnamen",
                style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
              ),
              const SizedBox(height: 6),
              Text(
                keterangan.isEmpty ? '-' : keterangan,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ),
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
      ],
    );
  }
}
