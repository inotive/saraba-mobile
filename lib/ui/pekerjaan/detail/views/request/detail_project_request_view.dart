import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

class DetailProjectRequestView extends StatelessWidget {
  final ProjectRequestItem item;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DetailProjectRequestView({
    super.key,
    required this.item,
    required this.canManage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Request'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
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
                            children: [
                              Expanded(
                                child: Text(
                                  item.requestId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              RequestStatusChip(status: item.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InfoColumn(
                                  label: 'Dibuat Oleh',
                                  value: item.createdBy,
                                ),
                              ),
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
                          const SizedBox(height: 14),
                          const Text(
                            'Request',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.requestText,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(item.grandTotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Daftar Item',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const RequestItemCard(
                            itemName: 'Barang 1',
                            qty: 10,
                            price: 10000,
                            total: 100000,
                          ),
                          const RequestItemCard(
                            itemName: 'Barang 2',
                            qty: 10,
                            price: 10000,
                            total: 100000,
                          ),
                          const RequestItemCard(
                            itemName: 'Barang 3',
                            qty: 10,
                            price: 10000,
                            total: 100000,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (canManage && item.status == RequestStatus.pending) ...[
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDelete,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF5B5B)),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Color(0xFFFF5B5B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onEdit,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF7944D)),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: Color(0xFFF7944D)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
