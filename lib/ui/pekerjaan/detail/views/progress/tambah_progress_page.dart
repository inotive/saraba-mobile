import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_progress_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_progress_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_progress_state.dart';

class TambahProgressPage extends StatefulWidget {
  final String projectId;
  final ProjectProgressLog? initialLog;
  final String pageTitle;

  const TambahProgressPage({
    super.key,
    required this.projectId,
    this.initialLog,
    this.pageTitle = 'Tambah Progress',
  });

  @override
  State<TambahProgressPage> createState() => _TambahProgressPageState();
}

class _TambahProgressPageState extends State<TambahProgressPage> {
  static const int _maxPhotoSizeInBytes = 5 * 1024 * 1024;
  final _imagePicker = ImagePicker();
  final _judulController = TextEditingController();
  final _progressController = TextEditingController();
  final _jumlahTukangController = TextEditingController();
  final _catatanController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final List<String> _existingImageUrls = [];
  late DateTime _selectedDate;

  bool get _isEditMode => widget.initialLog != null;

  @override
  void initState() {
    super.initState();
    final log = widget.initialLog;
    _judulController.text = log?.judul ?? '';
    _progressController.text = log?.progressPersen ?? '';
    _jumlahTukangController.text = log?.jumlahTukang?.toString() ?? '';
    _catatanController.text = log?.catatan ?? '';
    _selectedDate = _parseInitialDate(log?.tanggal) ?? DateTime.now();
    _existingImageUrls.addAll(log?.fotos ?? const []);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _progressController.dispose();
    _jumlahTukangController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);

    if (!mounted || pickedImages.isEmpty) {
      return;
    }

    final allowedImages = <XFile>[];
    for (final image in pickedImages) {
      final isAllowed = await _validatePhotoSize(image);
      if (!isAllowed) {
        continue;
      }
      allowedImages.add(image);
    }

    if (!mounted || allowedImages.isEmpty) {
      return;
    }

    setState(() {
      _selectedImages.addAll(allowedImages);
    });
  }

  Future<void> _pickFromCamera() async {
    final capturedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (!mounted || capturedImage == null) {
      return;
    }

    final isAllowed = await _validatePhotoSize(capturedImage);
    if (!mounted || !isAllowed) {
      return;
    }

    setState(() {
      _selectedImages.add(capturedImage);
    });
  }

  Future<bool> _validatePhotoSize(XFile image) async {
    final fileSize = await image.length();
    if (fileSize <= _maxPhotoSizeInBytes) {
      return true;
    }

    if (mounted) {
      _showPhotoLimitBanner(
        'Ukuran tiap foto maksimal 5 MB',
      );
    }
    return false;
  }

  void _showPhotoLimitBanner(String message) {
    StatusBanner.show(
      context,
      title: 'Upload Gagal',
      message: message,
      type: StatusBannerType.error,
    );
  }

  Future<void> _choosePhotoSource() async {
    final action = await showModalBottomSheet<_PhotoSourceAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const _PhotoSourceBottomSheet(),
    );

    if (action == null) {
      return;
    }

    if (action == _PhotoSourceAction.camera) {
      await _pickFromCamera();
      return;
    }

    await _pickFromGallery();
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

  void _submitProgress(BuildContext context) {
    FocusScope.of(context).unfocus();

    final judul = _judulController.text.trim();
    final progressPersen = int.tryParse(_progressController.text.trim()) ?? -1;
    final jumlahTukang =
        int.tryParse(_jumlahTukangController.text.trim()) ?? -1;
    final catatan = _catatanController.text.trim();

    if (judul.isEmpty) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Judul progress wajib diisi',
        type: StatusBannerType.error,
      );
      return;
    }

    if (progressPersen < 0 || progressPersen > 100) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Persentase progress harus di antara 0 sampai 100',
        type: StatusBannerType.error,
      );
      return;
    }

    if (catatan.isEmpty) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Catatan progress wajib diisi',
        type: StatusBannerType.error,
      );
      return;
    }

    if (jumlahTukang < 0) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Jumlah tukang wajib diisi dengan angka yang valid',
        type: StatusBannerType.error,
      );
      return;
    }

    context.read<TambahProgressBloc>().add(
      SubmitProgressRequested(
        projectId: widget.projectId,
        logId: widget.initialLog?.id.toString(),
        judul: judul,
        progressPersen: progressPersen,
        tanggal: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(_selectedDate),
        catatan: catatan,
        jumlahTukang: jumlahTukang,
        fotoPaths: _selectedImages.map((image) => image.path).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TambahProgressBloc(PekerjaanService()),
      child: BlocListener<TambahProgressBloc, TambahProgressState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            StatusBanner.show(
              context,
              title: 'Progress Gagal',
              message: state.errorMessage!,
              type: StatusBannerType.error,
            );
          }

          if (state.isSuccess && (state.successMessage?.isNotEmpty ?? false)) {
            Navigator.pop(context, state.successMessage);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: Column(
              children: [
                _TambahProgressHeader(title: widget.pageTitle),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ..._existingImageUrls.asMap().entries.map(
                                    (entry) => _ProgressPhotoTile(
                                      image: Image.network(
                                        entry.value,
                                        width: 92,
                                        height: 92,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }

                                              return Container(
                                                width: 92,
                                                height: 92,
                                                color: const Color(
                                                  0xFFF1F3F5,
                                                ),
                                                alignment: Alignment.center,
                                                child:
                                                    const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Color(
                                                              0xFFF7944D,
                                                            ),
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
                                      onRemove: () {
                                        setState(() {
                                          _existingImageUrls.removeAt(entry.key);
                                        });
                                      },
                                    ),
                                  ),
                                  ..._selectedImages.asMap().entries.map(
                                    (entry) => _ProgressPhotoTile(
                                      image: Image.file(
                                        File(entry.value.path),
                                        width: 92,
                                        height: 92,
                                        fit: BoxFit.cover,
                                      ),
                                      onRemove: () {
                                        setState(() {
                                          _selectedImages.removeAt(entry.key);
                                        });
                                      },
                                    ),
                                  ),
                                  if (_existingImageUrls.isEmpty &&
                                      _selectedImages.isEmpty)
                                    const _UploadPhotoBox(),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: OutlinedButton.icon(
                                  onPressed: _choosePhotoSource,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFB7C9F5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.file_upload_outlined,
                                    color: Color(0xFF2457F5),
                                  ),
                                  label: const Text(
                                    "Add Photos",
                                    style: TextStyle(
                                      color: Color(0xFF2457F5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel("Judul Progress"),
                              const SizedBox(height: 8),
                              _NormalField(
                                controller: _judulController,
                                hintText: "Masukkan judul progress",
                              ),
                              const SizedBox(height: 16),
                              const _FieldLabel("Input % Progress"),
                              const SizedBox(height: 8),
                              _SuffixField(
                                controller: _progressController,
                                hintText: "0",
                                suffixText: "%",
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Maksimal 100%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const _FieldLabel("Tanggal"),
                              const SizedBox(height: 8),
                              _DateField(
                                value: DateFormat(
                                  'dd MMMM yyyy',
                                  'id_ID',
                                ).format(_selectedDate),
                                onTap: _pickDate,
                              ),
                              const SizedBox(height: 16),
                              const _FieldLabel("Jumlah Tukang"),
                              const SizedBox(height: 8),
                              _NormalField(
                                controller: _jumlahTukangController,
                                hintText: "0",
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              const _FieldLabel("Catatan"),
                              const SizedBox(height: 8),
                              _NotesField(
                                controller: _catatanController,
                                hintText: "Berikan catatan progress",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<TambahProgressBloc, TambahProgressState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => _submitProgress(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7944D),
                            disabledBackgroundColor: const Color(0xFFF2B98F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state.isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isEditMode
                                      ? "Simpan Perubahan"
                                      : "Submit Progress",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _PhotoSourceAction { camera, gallery }

class _PhotoSourceBottomSheet extends StatelessWidget {
  const _PhotoSourceBottomSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, _PhotoSourceAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, _PhotoSourceAction.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _TambahProgressHeader extends StatelessWidget {
  final String title;

  const _TambahProgressHeader({required this.title});

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

DateTime? _parseInitialDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(rawDate);
  } catch (_) {
    return null;
  }
}

class _UploadPhotoBox extends StatelessWidget {
  const _UploadPhotoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF5D93E8),
          style: BorderStyle.solid,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: Color(0xFF2457F5), size: 26),
          SizedBox(height: 8),
          Text(
            "Upload",
            style: TextStyle(
              color: Color(0xFF2457F5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPhotoTile extends StatelessWidget {
  final Widget image;
  final VoidCallback onRemove;

  const _ProgressPhotoTile({
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image,
          ),
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xB3000000),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}

class _SuffixField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String suffixText;

  const _SuffixField({
    required this.controller,
    required this.hintText,
    required this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Color(0xFF6B7280)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _NormalField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  const _NormalField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _DateField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: value,
        hintStyle: const TextStyle(color: Color(0xFF1F1F1F)),
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _NotesField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}
