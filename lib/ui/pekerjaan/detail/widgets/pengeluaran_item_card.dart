import 'package:flutter/material.dart';

class PengeluaranItemCard extends StatelessWidget {
  final String title;
  final String volume;
  final String jumlahHarga;
  final String pengeluaran;
  final double progress;
  final String persentase;

  const PengeluaranItemCard({
    super.key,
    required this.title,
    required this.volume,
    required this.jumlahHarga,
    required this.pengeluaran,
    required this.progress,
    required this.persentase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEAFE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work_outline, color: Color(0xFF5D93E8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _TitleValueColumn(
                        label: "Nama Pekerjaan",
                        value: title,
                      ),
                    ),
                    Expanded(
                      child: _TitleValueColumn(
                        label: "Volume & Satuan",
                        value: volume,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _PriceRow(label: "Jumlah Harga", value: jumlahHarga),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _PriceRow(
                      label: "Pengeluaran",
                      value: pengeluaran,
                      valueColor: const Color(0xFF1B2A4A),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFD9D9DF),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFF7944D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          "Persentase",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F6EA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            persentase,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TitleValueColumn extends StatelessWidget {
  final String label;
  final String value;

  const _TitleValueColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
  final Color valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1B2A4A),
  });

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
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
