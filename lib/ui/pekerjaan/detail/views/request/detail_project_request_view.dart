import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_request_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_form_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/request_form_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/info_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_status_chip.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/request_item_card.dart';

class DetailProjectRequestView extends StatefulWidget {
  final String projectId;
  final ProjectRequestItem item;
  final bool canManage;
  // final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DetailProjectRequestView({
    super.key,
    required this.item,
    required this.canManage,
    // this.onEdit,
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

  Future<void> _handleEdit() async {
    final result = await Navigator.push<ProjectRequestFormResult>(
      context,
      MaterialPageRoute(
        builder: (_) => RequestFormPage(
          initialDate: widget.item.requestDate,
          initialRequestText: _requestText,
          initialItems: _items.map((e) {
            return RequestItem(
              id: e.namaItem,
              name: e.namaItem,
              quantity: e.qty,
              unitPrice: e.hargaSatuan.toDouble(),
            );
          }).toList(),
          pageTitle: 'Edit Request',
          submitLabel: 'Simpan Request',
        ),
      ),
    );

    if (result == null) return;

    final response = await _service.updateProjectRequest(
      projectId: widget.projectId,
      requestId: widget.item.requestId,
      tanggalPermintaan: DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
      ).format(result.requestDate),
      deskripsi: result.requestText,
      items: result.items,
    );

    if (!mounted) return;

    if (response == null || response.success != true) {
      StatusBanner.show(
        context,
        title: 'Gagal Update',
        message: response?.message ?? 'Terjadi kesalahan',
        type: StatusBannerType.error,
      );
      return;
    }

    // ✅ SUCCESS BANNER
    StatusBanner.show(
      context,
      title: 'Berhasil',
      message: 'Request berhasil diperbarui',
      type: StatusBannerType.success,
    );

    // 🔥 reload detail biar data fresh
    await _loadDetail();

    // 🔥 optional: kasih signal ke parent kalau dibutuhkan
    // Navigator.pop(context, true);
  }

  Future<void> _handleDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Request'),
          content: const Text('Yakin ingin menghapus request ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),

              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final response = await PekerjaanService().deleteProjectRequest(
      projectId: widget.projectId,
      requestId: widget.item.requestId,
    );

    if (!mounted) return;

    if (response == null || response.success != true) {
      StatusBanner.show(
        context,
        title: 'Gagal',
        message: response?.message ?? 'Gagal menghapus',
        type: StatusBannerType.error,
      );
      return;
    }

    StatusBanner.show(
      context,
      title: 'Berhasil',
      message: 'Request dihapus',
      type: StatusBannerType.success,
    );

    Navigator.pop(context, true);
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
                        const Center(child: CircularProgressIndicator())
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
            if (widget.canManage &&
                widget.item.status == RequestStatus.pending) ...[
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleDelete,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF5B5B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
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
                        onPressed: _handleEdit,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF7944D)),
                          backgroundColor: Color(0xFFF7944D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
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
