import 'package:flutter/material.dart';

class PengeluaranItemCard extends StatelessWidget {
  final String code;
  final String title;
  final String tanggal;
  final String summaryLabel;
  final String summaryValue;
  final String? secondaryLabel;
  final String? secondaryValue;
  final String iconAsset;
  final VoidCallback? onTap;

  const PengeluaranItemCard({
    super.key,
    required this.code,
    required this.title,
    required this.tanggal,
    required this.summaryLabel,
    required this.summaryValue,
    required this.iconAsset,
    this.secondaryLabel,
    this.secondaryValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: Center(
                    child: Image.asset(iconAsset, width: 42, height: 42),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              code,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8C8C8C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B2A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 126,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8C8C8C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tanggal,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B2A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _SummaryRow(label: summaryLabel, value: summaryValue),
                  if (secondaryLabel != null && secondaryValue != null) ...[
                    const SizedBox(height: 8),
                    _SummaryRow(label: secondaryLabel!, value: secondaryValue!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
          ),
        ),
        SizedBox(
          width: 126,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2A4A),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2A4A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
