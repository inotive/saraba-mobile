import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/repository/model/project/submit_progress_response_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_progress_page.dart';

class ProgressDetailPage extends StatefulWidget {
  final String projectId;
  final ProjectProgressLog log;
  final bool canEdit;

  const ProgressDetailPage({
    super.key,
    required this.projectId,
    required this.log,
    required this.canEdit,
  });

  @override
  State<ProgressDetailPage> createState() => _ProgressDetailPageState();
}

class _ProgressDetailPageState extends State<ProgressDetailPage> {
  final PekerjaanService _service = PekerjaanService();
  SubmittedProgressLog? _detail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _service.fetchProgressLogDetail(
      projectId: widget.projectId,
      logId: widget.log.id.toString(),
    );

    if (!mounted) {
      return;
    }

    if (response == null || response.success != true || response.data == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = response?.message.isNotEmpty == true
            ? response!.message
            : 'Gagal memuat detail progress';
      });
      return;
    }

    setState(() {
      _detail = response.data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final displayPhotos = detail?.fotos.map((item) => item.fotoUrl).toList() ??
        widget.log.fotos;
    final displayJudul = detail?.judul ?? widget.log.judul;
    final displayProgress =
        detail?.progressPersen.toString() ?? widget.log.progressPersen;
    final displayTanggal = detail?.tanggal ?? widget.log.tanggal;
    final displayJumlahTukang =
        detail?.jumlahTukang.toString() ?? widget.log.jumlahTukang?.toString() ?? '-';
    final displayCatatan = detail?.catatan ?? widget.log.catatan;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            const _DetailProgressHeader(title: 'Detail Progress'),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_errorMessage!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadDetail,
                              child: const Text('Muat Ulang'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        children: [
                          if (displayPhotos.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: SizedBox(
                                height: 92,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: displayPhotos.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    return _DetailProgressPhotoTile(
                                      imageUrl: displayPhotos[index],
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                _ProgressPhotoViewerPage(
                                                  images: displayPhotos,
                                                  initialIndex: index,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _DetailFieldLabel('Judul Progress'),
                                const SizedBox(height: 8),
                                _ReadOnlyField(value: displayJudul),
                                const SizedBox(height: 16),
                                const _DetailFieldLabel('Input % Progress'),
                                const SizedBox(height: 8),
                                _ReadOnlySuffixField(
                                  value: displayProgress,
                                  suffixText: '%',
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Maksimal 100%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const _DetailFieldLabel('Tanggal'),
                                const SizedBox(height: 8),
                                _ReadOnlyDateField(
                                  value: _formatDetailDate(displayTanggal),
                                ),
                                const SizedBox(height: 16),
                                const _DetailFieldLabel('Jumlah Tukang'),
                                const SizedBox(height: 8),
                                _ReadOnlyField(value: displayJumlahTukang),
                                const SizedBox(height: 16),
                                const _DetailFieldLabel('Catatan'),
                                const SizedBox(height: 8),
                                _ReadOnlyNotesField(value: displayCatatan),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            if (widget.canEdit && _errorMessage == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openOptions(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFF7944D),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFFF7944D),
                    ),
                    label: const Text(
                      'Pilihan',
                      style: TextStyle(
                        color: Color(0xFFF7944D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openOptions(BuildContext context) async {
    final action = await showModalBottomSheet<_ProgressAction>(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ProgressOptionsSheet(),
    );

    if (!context.mounted || action == null) {
      return;
    }

    if (action == _ProgressAction.edit) {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => TambahProgressPage(
            projectId: widget.projectId,
            pageTitle: 'Edit Progress',
            initialLog: _buildEditableLog(),
          ),
        ),
      );

      if (!context.mounted || result == null || result.isEmpty) {
        return;
      }

      Navigator.pop(
        context,
        ProgressDetailActionResult(
          title: 'Progress Berhasil',
          message: result,
        ),
      );
      return;
    }

    final shouldDelete = await _showDeleteConfirmation(context);
    if (!context.mounted || shouldDelete != true) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await PekerjaanService().deleteProgressLog(
      projectId: widget.projectId,
      logId: widget.log.id.toString(),
    );

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) {
      return;
    }

    if (result?.success == true) {
      Navigator.pop(
        context,
        ProgressDetailActionResult(
          title: 'Progress Berhasil',
          message: result?.message.isNotEmpty == true
              ? result!.message
              : 'Progress berhasil dihapus',
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      ProgressDetailActionResult(
        title: 'Progress Gagal',
        message: result?.message.isNotEmpty == true
            ? result!.message
            : 'Gagal menghapus progress',
        isSuccess: false,
      ),
    );
  }

  ProjectProgressLog _buildEditableLog() {
    final detail = _detail;
    if (detail == null) {
      return widget.log;
    }

    return ProjectProgressLog(
      id: detail.id,
      judul: detail.judul,
      progressPersen: detail.progressPersen.toString(),
      tanggal: detail.tanggal,
      jumlahTukang: detail.jumlahTukang,
      catatan: detail.catatan,
      fotos: detail.fotos
          .map((foto) => foto.fotoUrl)
          .where((url) => url.isNotEmpty)
          .toList(),
      user: ProjectUserSummary(
        id: detail.user?.id ?? widget.log.user.id,
        name: detail.user?.name ?? widget.log.user.name,
      ),
      createdAt: detail.createdAt,
    );
  }
}

class ProgressDetailActionResult {
  final String title;
  final String message;
  final bool isSuccess;

  const ProgressDetailActionResult({
    required this.title,
    required this.message,
    this.isSuccess = true,
  });
}

enum _ProgressAction { edit, delete }

Future<bool?> _showDeleteConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Hapus Progress'),
        content: const Text('Apakah kamu yakin ingin menghapus progress ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC52222),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

class _ProgressOptionsSheet extends StatelessWidget {
  const _ProgressOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilihan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _ProgressOptionRow(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: () => Navigator.pop(context, _ProgressAction.edit),
            ),
            _ProgressOptionRow(
              icon: Icons.delete_outline,
              label: 'Hapus Progress',
              color: const Color(0xFFFF5B5B),
              onTap: () => Navigator.pop(context, _ProgressAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressOptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ProgressOptionRow({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF1F1F1F),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailProgressHeader extends StatelessWidget {
  final String title;

  const _DetailProgressHeader({required this.title});

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

class _DetailFieldLabel extends StatelessWidget {
  final String label;

  const _DetailFieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;

  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
      ),
    );
  }
}

class _ReadOnlySuffixField extends StatelessWidget {
  final String value;
  final String suffixText;

  const _ReadOnlySuffixField({
    required this.value,
    required this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Text(
              suffixText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyDateField extends StatelessWidget {
  final String value;

  const _ReadOnlyDateField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
              ),
            ),
          ),
          Container(
            width: 44,
            height: 46,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF5D93E8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyNotesField extends StatelessWidget {
  final String value;

  const _ReadOnlyNotesField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Color(0xFF1F1F1F),
        ),
      ),
    );
  }
}

class _DetailProgressPhotoTile extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _DetailProgressPhotoTile({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 92,
          height: 92,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              width: 92,
              height: 92,
              color: const Color(0xFFF1F3F5),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFF7944D),
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            width: 92,
            height: 92,
            color: const Color(0xFFF1F3F5),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFF9AA0A6),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressPhotoViewerPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _ProgressPhotoViewerPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_ProgressPhotoViewerPage> createState() =>
      _ProgressPhotoViewerPageState();
}

class _ProgressPhotoViewerPageState extends State<_ProgressPhotoViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.images.length > 1
        ? '${_currentIndex + 1}/${widget.images.length}'
        : 'Foto Progress';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Image.network(
                widget.images[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (_, _, _) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white70,
                  size: 48,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String _formatDetailDate(String rawDate) {
  try {
    final parsed = DateTime.parse(rawDate);
    return DateFormat('dd MMMM yyyy', 'id_ID').format(parsed);
  } catch (_) {
    try {
      final parsed = DateFormat('yyyy-MM-dd').parseStrict(rawDate);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }
}
