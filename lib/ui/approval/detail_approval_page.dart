import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

class DetailApprovalPage extends StatelessWidget {
  final ProjectRequestItem item;

  const DetailApprovalPage({super.key, required this.item});

  void _approve(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request Disetujui')));
  }

  void _reject(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request Ditolak')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Approval'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
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
                        'Catatan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8C8C8C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(item.requestText),
                      const SizedBox(height: 16),
                      const Text(
                        'Daftar Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _reject(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF5B5B)),
                      ),
                      child: const Text(
                        'Tolak',
                        style: TextStyle(color: Color(0xFFFF5B5B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _approve(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7944D),
                      ),
                      child: const Text(
                        'Setujui',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
