import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:saraba_mobile/ui/approval/bloc/approval_bloc.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_event.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_item_card.dart';

class DetailApprovalPage extends StatefulWidget {
  final String requestId;

  const DetailApprovalPage({super.key, required this.requestId});

  @override
  State<DetailApprovalPage> createState() => _DetailApprovalPageState();
}

class _DetailApprovalPageState extends State<DetailApprovalPage> {
  @override
  void initState() {
    super.initState();
    context.read<ApprovalBloc>().add(FetchRequestDetail(widget.requestId));
  }

  void _approve() {
    context.read<ApprovalBloc>().add(ApproveRequest(widget.requestId));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request Disetujui')));

    Navigator.pop(context);
  }

  void _reject() {
    context.read<ApprovalBloc>().add(RejectRequest(widget.requestId));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request Ditolak')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Approval'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: BlocBuilder<ApprovalBloc, ApprovalState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final detail = state.detail;

          if (detail == null) {
            return const Center(child: Text('Detail tidak ditemukan'));
          }

          return Column(
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
                                detail.idPermintaan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _StatusChip(label: detail.statusLabel),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InfoColumn(
                                label: 'Dibuat Oleh',
                                value: detail.createdBy,
                              ),
                            ),
                            Expanded(
                              child: InfoColumn(
                                label: 'Tanggal Request',
                                value: detail.tanggalPermintaan,
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
                                value: '${detail.totalItem} Item',
                              ),
                            ),
                            Expanded(
                              child: InfoColumn(
                                label: 'Grand Total',
                                value: NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(detail.grandTotal),
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
                        Text(detail.deskripsi),
                        const SizedBox(height: 16),
                        const Text(
                          'Daftar Item',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        ...detail.items.map(
                          (item) => RequestItemCard(
                            itemName: item.namaItem,
                            qty: item.qty,
                            price: item.hargaSatuan,
                            total: item.total,
                          ),
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
                        onPressed: _reject,
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
                        onPressed: _approve,
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
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// class _RequestItemCard extends StatelessWidget {
//   final String itemName;
//   final int qty;
//   final int price;
//   final int total;
//   const _RequestItemCard({
//     required this.itemName,
//     required this.qty,
//     required this.price,
//     required this.total,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final currency = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(itemName, style: const TextStyle(fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),
//           Text('$qty x ${currency.format(price)}'),
//           const SizedBox(height: 6),
//           Text(
//             currency.format(total),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
