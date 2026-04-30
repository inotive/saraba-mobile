import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_request_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';

class DetailProjectRequestView extends StatefulWidget {
  final String projectId;
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
    required this.projectId,
  });

  @override
  State<DetailProjectRequestView> createState() =>
      _DetailProjectRequestViewState();
}

class _DetailProjectRequestViewState extends State<DetailProjectRequestView> {
  final PekerjaanService _service = PekerjaanService();

  bool _isLoading = true;
  String? _error;

  List<ProjectRequestItemDetail> _items = [];
  String _requestText = '';
  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await _service.fetchProjectRequestDetail(
      projectId: widget.projectId,
      requestId: widget.item.requestId,
    );

    if (!mounted) return;

    if (response == null) {
      setState(() {
        _error = 'Gagal memuat detail request';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _items = List<ProjectRequestItemDetail>.from(response.data.items);
      _requestText = response.data.deskripsi;
      _isLoading = false;
    });
  }

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
                      /// HEADER
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.displayId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          RequestStatusChip(status: widget.item.status),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// ROW 1
                      Row(
                        children: [
                          Expanded(
                            child: InfoColumn(
                              label: 'Dibuat Oleh',
                              value: widget.item.createdBy,
                            ),
                          ),
                          Expanded(
                            child: InfoColumn(
                              label: 'Tanggal Request',
                              value: DateFormat(
                                'dd MMMM yyyy',
                                'id_ID',
                              ).format(widget.item.requestDate),
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// ROW 2
                      Row(
                        children: [
                          Expanded(
                            child: InfoColumn(
                              label: 'Total Item',
                              value: '${widget.item.totalItem} Item',
                            ),
                          ),
                          Expanded(
                            child: InfoColumn(
                              label: 'Grand Total',
                              value: NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(widget.item.grandTotal),
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
                      Text(_requestText),
                      const SizedBox(height: 16),
                      const Text(
                        'Daftar Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8C8C8C),
                          ),
                        )
                      else if (_items.isEmpty)
                        const Text(
                          'Belum ada item',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8C8C8C),
                          ),
                        )
                      else
                        ..._items.map(
                          (e) => RequestItemCard(
                            itemName: e.namaItem,
                            qty: e.qty.toInt(),
                            price: e.hargaSatuan.toInt(),
                            total: e.total.toInt(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.canManage &&
                widget.item.status == RequestStatus.pending) ...[
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onDelete,
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
                        onPressed: widget.onEdit,
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
