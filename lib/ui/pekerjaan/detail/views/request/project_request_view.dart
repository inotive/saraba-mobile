import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/detail_project_request_view.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/mappers/project_request_mapper.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_form_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/project_request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/request_form_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/widgets/request_card.dart';

class ProjectRequestView extends StatefulWidget {
  final String projectId;
  final bool canEdit;

  const ProjectRequestView({
    super.key,
    required this.projectId,
    this.canEdit = true,
  });

  @override
  State<ProjectRequestView> createState() => _ProjectRequestViewState();
}

class _ProjectRequestViewState extends State<ProjectRequestView> {
  final PekerjaanService _service = PekerjaanService();
  List<ProjectRequestItem> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadRequests();
  }

  void _loadCurrentUser() {
    final box = Hive.box<User>('userBox');
    _currentUserName = box.get('current_user')?.name.trim().toLowerCase() ?? '';
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _service.fetchProjectRequests(widget.projectId);

    if (!mounted) {
      return;
    }

    if (response == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat request proyek';
      });
      return;
    }

    setState(() {
      _requests = response.data.map(ProjectRequestMapper.fromResponse).toList();

      _isLoading = false;
    });
  }

  Future<void> _openCreateRequest() async {
    final result = await Navigator.push<ProjectRequestFormResult>(
      context,
      MaterialPageRoute(builder: (_) => const RequestFormPage()),
    );

    if (!mounted || result == null) {
      return;
    }

    final response = await _service.submitProjectRequest(
      projectId: widget.projectId,
      tanggalPermintaan: DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
      ).format(result.requestDate),
      deskripsi: result.requestText,
      items: result.items,
    );

    if (!mounted) {
      return;
    }

    if (response == null || response.success != true || response.data == null) {
      StatusBanner.show(
        context,
        title: 'Request Gagal',
        message: response?.message.isNotEmpty == true
            ? response!.message
            : 'Gagal mengirim request proyek',
        type: StatusBannerType.error,
      );
      return;
    }

    setState(() {
      _requests.insert(0, ProjectRequestMapper.fromSubmit(response.data!));
    });

    StatusBanner.show(
      context,
      title: 'Request Berhasil',
      message: response.message,
      type: StatusBannerType.success,
    );
  }

  Future<void> _openEditRequest(ProjectRequestItem item) async {
    final detail = await _service.fetchProjectRequestDetail(
      projectId: widget.projectId,
      requestId: item.requestId,
    );

    if (!mounted || detail == null) {
      StatusBanner.show(
        context,
        title: 'Gagal',
        message: 'Tidak bisa mengambil detail request',
        type: StatusBannerType.error,
      );
      return;
    }

    final mappedItems = detail.data.items.map((e) {
      return OperasionalExpenseItem(
        id: e.namaItem,
        name: e.namaItem,
        quantity: e.qty,
        amount: e.hargaSatuan.toDouble(),
        note: '',
        attachments: [],
      );
    }).toList();

    final result = await Navigator.push<ProjectRequestFormResult>(
      context,
      MaterialPageRoute(
        builder: (_) => RequestFormPage(
          initialDate: item.requestDate,
          initialRequestText: detail.data.deskripsi,
          initialItems: mappedItems, 
          pageTitle: 'Edit Request',
          submitLabel: 'Simpan Request',
        ),
      ),
    );

    if (!mounted || result == null) return;

    final response = await _service.updateProjectRequest(
      projectId: widget.projectId,
      requestId: item.requestId,
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
        title: 'Update Gagal',
        message: response?.message ?? 'Gagal update',
        type: StatusBannerType.error,
      );
      return;
    }

    await _loadRequests();
  }

  Future<void> _deleteRequest(ProjectRequestItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Request'),
          content: const Text('Apakah kamu yakin ingin menghapus request ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5B5B),
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final response = await _service.deleteProjectRequest(
      projectId: widget.projectId,
      requestId: item.requestId,
    );

    if (!mounted) {
      return;
    }

    if (response == null || response.success != true) {
      StatusBanner.show(
        context,
        title: 'Hapus Gagal',
        message: response?.message.isNotEmpty == true
            ? response!.message
            : 'Gagal menghapus request proyek',
        type: StatusBannerType.error,
      );
      return;
    }

    setState(() {
      _requests.removeWhere((request) => request.requestId == item.requestId);
    });

    StatusBanner.show(
      context,
      title: 'Request Dihapus',
      message: response.message,
      type: StatusBannerType.success,
    );
  }

  void _openDetail(ProjectRequestItem item) {
    final canManageItem =
        widget.canEdit &&
        item.status == RequestStatus.pending &&
        _currentUserName.isNotEmpty &&
        item.createdBy.trim().toLowerCase() == _currentUserName;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailProjectRequestView(
          projectId: widget.projectId,
          item: item,
          canManage: canManageItem,
          onEdit: canManageItem ? () => _openEditRequest(item) : null,
          onDelete: canManageItem ? () => _deleteRequest(item) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadRequests,
                child: const Text('Muat Ulang'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          child: _requests.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada request',
                    style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
                  ),
                )
              : ListView.separated(
                  itemCount: _requests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _requests[index];
                    return RequestCard(
                      item: item,
                      onDetail: () => _openDetail(item),
                    );
                  },
                ),
        ),
        if (widget.canEdit)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _openCreateRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7944D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Tambah Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
