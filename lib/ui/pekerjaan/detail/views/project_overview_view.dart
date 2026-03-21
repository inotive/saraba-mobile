import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';

class ProjectOverviewView extends StatelessWidget {
  final ProjectModel project;

  const ProjectOverviewView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
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
              "${(project.progress * 100).toInt()}%",
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
                value: project.progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFF7944D)),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: _LabelValueColumn(
                    label: "Mulai",
                    value: "01/01/2026",
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: _LabelValueColumn(
                    label: "Selesai",
                    value: "30/04/2026",
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const _InfoRow(label: "Dinas", value: "Dinas PUPR"),
            const SizedBox(height: 8),
            const _InfoRow(label: "Lokasi", value: "Surabaya"),
            const SizedBox(height: 8),
            _InfoRow(label: "Nilai Proyek", value: project.nilai),
            const SizedBox(height: 8),
            const _StatusRow(label: "Status", value: "Aktif"),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const _InfoRow(label: "Tanggal Mulai", value: "01 Januari 2026"),
            const SizedBox(height: 8),
            const _InfoRow(label: "Tanggal Berakhir", value: "30 April 2026"),
            const SizedBox(height: 8),
            const _InfoRow(label: "Durasi Pekerjaan", value: "120 Hari"),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const _InfoRow(
              label: "Estimasi Pengeluaran",
              value: "Rp 200.000.000",
            ),
            const SizedBox(height: 8),
            _InfoRow(label: "Pengeluaran Saat Ini", value: project.pengeluaran),
            const SizedBox(height: 8),
            const _InfoRow(label: "Sisa Budget", value: "Rp 80.000.000"),
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
                  "${(project.progress * 100).toInt()}% Dari Estimasi",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _BudgetBar(progress: project.progress),
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
            color: const Color(0xFFE6F7E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2E7D32),
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
