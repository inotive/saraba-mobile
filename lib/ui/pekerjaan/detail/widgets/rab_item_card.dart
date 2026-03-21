import 'package:flutter/material.dart';

class RabItemCard extends StatelessWidget {
  final String titleLabel;
  final String title;
  final String volume;
  final String hargaSatuan;
  final String jumlahHarga;
  final String type;

  const RabItemCard({
    super.key,
    required this.titleLabel,
    required this.title,
    required this.volume,
    required this.hargaSatuan,
    required this.jumlahHarga,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isMaterial = type == 'material';

    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEAFE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMaterial ? Icons.storefront_outlined : Icons.work_outline,
                  color: const Color(0xFF5D93E8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TitleValueColumn(label: titleLabel, value: title),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TitleValueColumn(
                        label: 'Volume & Satuan',
                        value: volume,
                        alignEnd: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _PriceRow(label: 'Harga Satuan', value: hargaSatuan),
                const SizedBox(height: 8),
                _PriceRow(label: 'Jumlah Harga', value: jumlahHarga),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleValueColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _TitleValueColumn({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B2A4A),
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B2A4A),
          ),
        ),
      ],
    );
  }
}
