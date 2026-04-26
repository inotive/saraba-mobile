import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

class RequestCard extends StatelessWidget {
  final ProjectRequestItem item;
  final VoidCallback? onDetail;

  const RequestCard({super.key, required this.item, this.onDetail});

  @override
  Widget build(BuildContext context) {
    final item = this.item;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      item.requestId,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ],
                ),
              ),
              RequestStatusChip(status: item.status),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: InfoColumn(label: 'Dibuat Oleh', value: item.createdBy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoColumn(
                  label: 'Tanggal Request',
                  value: DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(item.requestDate),
                  alignEnd: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: InfoColumn(
                  label: 'Total Item',
                  value: '${item.totalItem} Item',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoColumn(
                  label: 'Grand Total',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(item.grandTotal),
                  alignEnd: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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
