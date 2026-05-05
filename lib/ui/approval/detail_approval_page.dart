import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:saraba_mobile/ui/approval/bloc/approval_bloc.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_event.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/utils/header.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/request_item_card.dart';

class DetailApprovalPage extends StatefulWidget {
  final String requestId;
  final String pageTitle;

  const DetailApprovalPage({
    super.key,
    required this.requestId,
    this.pageTitle = 'Detail Request Approval',
  });

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
      body: SafeArea(
        child: Column(
          children: [
            TambahPengeluaranHeader(title: widget.pageTitle),
            Expanded(
              child: BlocBuilder<ApprovalBloc, ApprovalState>(
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
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// HEADER
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Id Request',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF8C8C8C),
                                            ),
                                          ),
                                          Text(
                                            detail.idPermintaan,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RequestStatusChip(
                                      status: mapStatus(detail.statusLabel),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// INFO
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
                                        value:
                                            DateFormat(
                                              'dd MMMM yyyy',
                                              'id_ID',
                                            ).format(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).parse(detail.tanggalPermintaan),
                                            ),
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
                                Text(
                                  detail.deskripsi.trim().isEmpty
                                      ? 'Tidak ada catatan'
                                      : detail.deskripsi,
                                  style: TextStyle(
                                    color: detail.deskripsi.trim().isEmpty
                                        ? const Color(0xFF8C8C8C)
                                        : const Color(0xFF1F1F1F),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Grand Total',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8C8C8C),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        formatCurrency(
                                          (detail.grandTotal.toDouble()),
                                        ),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1F1F1F),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// ITEMS
                                const Text(
                                  'Daftar Item',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),

                                ...detail.items.map(
                                  (e) => RequestItemCard(
                                    item: RequestItem(
                                      id: e.namaItem,
                                      name: e.namaItem,
                                      quantity: e.qty,
                                      unitPrice: e.hargaSatuan.toDouble(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// BUTTONS
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _reject,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xFFFF5B5B)),
                                  backgroundColor: Color(0xFFFF5B5B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  'Tolak',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _approve,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xFFF7944D)),
                                  backgroundColor: const Color(0xFFF7944D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  minimumSize: const Size.fromHeight(50),
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
            ),
          ],
        ),
      ),
    );
  }
}
