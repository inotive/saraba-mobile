import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_model.dart';

class ApprovalCard extends StatelessWidget {
  final RequestApprovalData item;
  final VoidCallback? onDetail;

  const ApprovalCard({super.key, required this.item, this.onDetail});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ID REQUEST
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Id Request',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      item.idPermintaan,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS
              _StatusChip(label: item.statusLabel),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoColumn(label: 'Dibuat Oleh', value: item.createdBy),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _InfoColumn(
                  label: 'Tanggal Request',
                  value: item.tanggalPermintaan,
                  alignEnd: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// TOTAL
          Row(
            children: [
              Expanded(
                child: _InfoColumn(
                  label: 'Total Item',
                  value: '${item.totalItem} Item',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _InfoColumn(
                  label: 'Grand Total',
                  value: currency.format(item.grandTotal),
                  alignEnd: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BUTTON DETAIL
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onDetail,

              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1F1F1F)),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                minimumSize: const Size(double.infinity, 44),
              ),

              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _InfoColumn({
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

        const SizedBox(height: 2),

        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.orange.shade100;
    Color textColor = Colors.orange;

    /// Optional status coloring
    if (label.toLowerCase().contains('approve')) {
      bgColor = Colors.green.shade100;
      textColor = Colors.green;
    }

    if (label.toLowerCase().contains('reject')) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
