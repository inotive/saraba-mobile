import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

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
                      'Projek',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.proyekName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 14),
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
              RequestStatusChip(status: mapStatus(item.statusLabel)),
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
                  value: DateFormat('dd MMMM yyyy', 'id_ID').format(
                    DateFormat('dd/MM/yyyy').parse(item.tanggalPermintaan),
                  ),
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
                child: InfoColumn(
                  label: 'Total Item',
                  value: '${item.totalItem} Item',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: InfoColumn(
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
                side: const BorderSide(color: Color(0xFFF7944D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                minimumSize: const Size.fromHeight(40),
              ),

              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  color: Color(0xFFF7944D),
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
