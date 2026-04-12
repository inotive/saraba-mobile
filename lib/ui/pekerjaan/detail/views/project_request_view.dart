import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectRequestView extends StatefulWidget {
  const ProjectRequestView({super.key});

  @override
  State<ProjectRequestView> createState() => _ProjectRequestViewState();
}

class _ProjectRequestViewState extends State<ProjectRequestView> {
  late final List<ProjectRequestItem> _requests = [
    ProjectRequestItem(
      id: '20260410001',
      createdBy: 'Lily Karmila',
      requestDate: DateTime(2026, 4, 10),
      status: RequestStatus.pending,
      requestText:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n'
          'Suspendisse iaculis augue massa, eu fringilla ex tempor eu.\n'
          'Aenean a nulla efficitur, efficitur ante ac.',
    ),
    ProjectRequestItem(
      id: '20260410002',
      createdBy: 'Lily Karmila',
      requestDate: DateTime(2026, 4, 10),
      status: RequestStatus.processed,
      requestText:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n'
          'Suspendisse iaculis augue massa, eu fringilla ex tempor eu.\n'
          'Aenean a nulla efficitur, efficitur ante ac.',
    ),
    ProjectRequestItem(
      id: '20260410003',
      createdBy: 'Lily Karmila',
      requestDate: DateTime(2026, 4, 10),
      status: RequestStatus.done,
      requestText:
          '- Lorem ipsum dolor sit amet,\n'
          '- consectetur adipiscing elit.\n'
          '- Suspendisse iaculis augue massa,\n'
          '- eu fringilla ex tempor eu.\n'
          '- Aenean a nulla efficitur,\n'
          '  efficitur ante ac.\n'
          '- Lorem ipsum dolor sit amet,\n'
          '- consectetur adipiscing elit.\n'
          '- Suspendisse iaculis augue massa,\n'
          '- eu fringilla ex tempor eu.\n'
          '- Aenean a nulla efficitur,\n'
          '  efficitur ante ac.',
    ),
  ];

  Future<void> _openCreateRequest() async {
    final result = await Navigator.push<ProjectRequestFormResult>(
      context,
      MaterialPageRoute(builder: (_) => const RequestFormPage()),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _requests.insert(
        0,
        ProjectRequestItem(
          id: _buildNextRequestId(),
          createdBy: 'Lily Karmila',
          requestDate: result.requestDate,
          status: RequestStatus.pending,
          requestText: result.requestText,
        ),
      );
    });
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

    final index = _requests.indexWhere((request) => request.id == item.id);
    if (index == -1) {
      return;
    }

    setState(() {
      _requests[index] = item.copyWith(
        requestDate: result.requestDate,
        requestText: result.requestText,
      );
    });
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

    setState(() {
      _requests.removeWhere((request) => request.id == item.id);
    });
  }

  String _buildNextRequestId() {
    final now = DateTime.now();
    final datePrefix = DateFormat('yyyyMMdd').format(now);
    final nextNumber = _requests.length + 1;
    return '$datePrefix${nextNumber.toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          child: ListView.separated(
            itemCount: _requests.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Text(
                  'Request',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                );
              }

              final item = _requests[index - 1];
              return _RequestCard(
                item: item,
                onEdit: item.status == RequestStatus.pending
                    ? () => _openEditRequest(item)
                    : null,
                onDelete: item.status == RequestStatus.pending
                    ? () => _deleteRequest(item)
                    : null,
              );
            },
          ),
        ),
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
