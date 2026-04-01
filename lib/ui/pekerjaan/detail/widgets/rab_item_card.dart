import 'package:flutter/material.dart';

class RabDetailRowData {
  final String title;
  final String subtitle;
  final String category;
  final String amount;

  const RabDetailRowData({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.amount,
  });
}

class RabItemCard extends StatelessWidget {
  final String title;
  final int totalItem;
  final String totalHarga;
  final bool isExpanded;
  final List<RabDetailRowData> detailRows;
  final String iconAsset;
  final VoidCallback onToggle;

  const RabItemCard({
    super.key,
    required this.title,
    required this.totalItem,
    required this.totalHarga,
    required this.isExpanded,
    required this.detailRows,
    required this.iconAsset,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SummaryRow(label: 'Total Item', value: totalItem.toString()),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Total harga', value: totalHarga),
          if (isExpanded && detailRows.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...detailRows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RabDetailRow(data: row),
              ),
            ),
          ],
          const SizedBox(height: 6),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? 'Lebih Sedikit' : 'Lihat Detail',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF3D3D3D)),
                      ),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 14,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF525252),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

class _RabDetailRow extends StatelessWidget {
  final RabDetailRowData data;

  const _RabDetailRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CategoryPill(label: data.category),
              const SizedBox(height: 8),
              Text(
                data.amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;

  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF8DB7F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3E6DB1),
        ),
      ),
    );
  }
}
