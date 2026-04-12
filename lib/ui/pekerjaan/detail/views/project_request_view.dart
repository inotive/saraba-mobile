import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_request_response_model.dart';
import 'package:saraba_mobile/repository/model/project/project_request_submit_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';

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

  @override
  void initState() {
    super.initState();
    _loadRequests();
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
      _requests = response.data.map(_mapRequestItem).toList();
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
      _requests.insert(0, _mapSubmittedRequestItem(response.data!));
    });

    StatusBanner.show(
      context,
      title: 'Request Berhasil',
      message: response.message,
      type: StatusBannerType.success,
    );
  }

  Future<void> _openEditRequest(ProjectRequestItem item) async {
    final result = await Navigator.push<ProjectRequestFormResult>(
      context,
      MaterialPageRoute(
        builder: (_) => RequestFormPage(
          initialDate: item.requestDate,
          initialRequestText: item.requestText,
          pageTitle: 'Edit Request',
          submitLabel: 'Simpan Request',
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    final response = await _service.updateProjectRequest(
      projectId: widget.projectId,
      requestId: item.id,
      tanggalPermintaan: DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
      ).format(result.requestDate),
      deskripsi: result.requestText,
    );

    if (!mounted) {
      return;
    }

    if (response == null || response.success != true || response.data == null) {
      StatusBanner.show(
        context,
        title: 'Update Gagal',
        message: response?.message.isNotEmpty == true
            ? response!.message
            : 'Gagal memperbarui request proyek',
        type: StatusBannerType.error,
      );
      return;
    }

    final updatedItem = _mapSubmittedRequestItem(response.data!);
    final index = _requests.indexWhere((request) => request.id == item.id);
    if (index == -1) {
      return;
    }

    setState(() {
      _requests[index] = updatedItem.copyWith(
        createdBy: item.createdBy,
      );
    });

    StatusBanner.show(
      context,
      title: 'Update Berhasil',
      message: response.message,
      type: StatusBannerType.success,
    );
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
      requestId: item.id,
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
      _requests.removeWhere((request) => request.id == item.id);
    });

    StatusBanner.show(
      context,
      title: 'Request Dihapus',
      message: response.message,
      type: StatusBannerType.success,
    );
  }

  ProjectRequestItem _mapRequestItem(ProjectRequestData item) {
    return ProjectRequestItem(
      id: item.id.toString(),
      createdBy: '-',
      requestDate: _parseRequestDate(item.tanggalPermintaan) ?? DateTime.now(),
      status: _mapRequestStatus(item.status),
      requestText: item.deskripsi,
    );
  }

  ProjectRequestItem _mapSubmittedRequestItem(ProjectRequestSubmitData item) {
    return ProjectRequestItem(
      id: item.id.toString(),
      createdBy: '-',
      requestDate: _parseRequestDate(item.tanggalPermintaan) ?? DateTime.now(),
      status: _mapRequestStatus(item.status),
      requestText: item.deskripsi,
    );
  }

  DateTime? _parseRequestDate(String value) {
    if (value.isEmpty) {
      return null;
    }

    try {
      return DateFormat('dd/MM/yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  RequestStatus _mapRequestStatus(String value) {
    switch (value.trim().toLowerCase()) {
      case 'processed':
        return RequestStatus.processed;
      case 'done':
        return RequestStatus.done;
      case 'pending':
      default:
        return RequestStatus.pending;
    }
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
                    return _RequestCard(
                      item: item,
                      onEdit: widget.canEdit &&
                              item.status == RequestStatus.pending
                          ? () => _openEditRequest(item)
                          : null,
                      onDelete: widget.canEdit &&
                              item.status == RequestStatus.pending
                          ? () => _deleteRequest(item)
                          : null,
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

class RequestFormPage extends StatefulWidget {
  final DateTime? initialDate;
  final String? initialRequestText;
  final String pageTitle;
  final String submitLabel;

  const RequestFormPage({
    super.key,
    this.initialDate,
    this.initialRequestText,
    this.pageTitle = 'Tambah Request',
    this.submitLabel = '+ Kirim Request',
  });

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _selectedDate;

  bool get _canSubmit => _descriptionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _descriptionController.text = widget.initialRequestText ?? '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submit() {
    final requestText = _descriptionController.text;
    if (requestText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi request wajib diisi')),
      );
      return;
    }

    Navigator.pop(
      context,
      ProjectRequestFormResult(
        requestDate: _selectedDate,
        requestText: requestText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _RequestHeader(title: widget.pageTitle),
            Expanded(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFD7E3FF)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Request',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _RequestDateField(
                              value: DateFormat(
                                'dd/MM/yyyy',
                                'id_ID',
                              ).format(_selectedDate),
                              onTap: _pickDate,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              onChanged: (_) => setState(() {}),
                              minLines: 10,
                              maxLines: 14,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF7944D),
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7944D),
                            disabledBackgroundColor: const Color(0xFFFBD6BB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.submitLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatefulWidget {
  final ProjectRequestItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _RequestCard({required this.item, this.onEdit, this.onDelete});

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final requestText = item.requestText;
    final shouldShowToggle =
        requestText.length > 120 || '\n'.allMatches(requestText).length >= 2;

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
                      item.id,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ],
                ),
              ),
              _RequestStatusChip(status: item.status),
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
          const Text(
            'Request',
            style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
          ),
          const SizedBox(height: 4),
          Text(
            requestText,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF1F1F1F),
            ),
          ),
          if (shouldShowToggle) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Lebih Sedikit' : 'Lebih Banyak',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D93E8),
                  ),
                ),
              ),
            ),
          ],
          if (item.status == RequestStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: widget.onDelete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF5B5B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(92, 38),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Color(0xFFFF5B5B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: widget.onEdit,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF7944D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(92, 38),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xFFF7944D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestHeader extends StatelessWidget {
  final String title;

  const _RequestHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestDateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _RequestDateField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1F1F1F)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
            Container(
              width: 44,
              height: 48,
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFF1F1F1F))),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF5D93E8),
              ),
            ),
          ],
        ),
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
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

class _RequestStatusChip extends StatelessWidget {
  final RequestStatus status;

  const _RequestStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (status) {
      RequestStatus.pending => (
        'Pending',
        const Color(0xFFF7944D),
        const Color(0xFFFFF4EA),
      ),
      RequestStatus.processed => (
        'Processed',
        const Color(0xFF5D93E8),
        const Color(0xFFEEF5FF),
      ),
      RequestStatus.done => (
        'Done',
        const Color(0xFF2FA44F),
        const Color(0xFFEFFAF2),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class ProjectRequestItem {
  final String id;
  final String createdBy;
  final DateTime requestDate;
  final RequestStatus status;
  final String requestText;

  const ProjectRequestItem({
    required this.id,
    required this.createdBy,
    required this.requestDate,
    required this.status,
    required this.requestText,
  });

  ProjectRequestItem copyWith({
    String? id,
    String? createdBy,
    DateTime? requestDate,
    RequestStatus? status,
    String? requestText,
  }) {
    return ProjectRequestItem(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      requestText: requestText ?? this.requestText,
    );
  }
}

class ProjectRequestFormResult {
  final DateTime requestDate;
  final String requestText;

  const ProjectRequestFormResult({
    required this.requestDate,
    required this.requestText,
  });
}

enum RequestStatus { pending, processed, done }
