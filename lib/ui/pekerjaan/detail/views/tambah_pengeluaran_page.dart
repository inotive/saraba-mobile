import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_state.dart';

class TambahPengeluaranPage extends StatefulWidget {
  final String projectId;

  const TambahPengeluaranPage({super.key, required this.projectId});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _imagePicker = ImagePicker();
  final _namaItemController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _keteranganController = TextEditingController();
  XFile? _selectedImage;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _namaItemController.dispose();
    _jumlahController.dispose();
    _kategoriController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
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

  void _submitPengeluaran(BuildContext context) {
    FocusScope.of(context).unfocus();

    final namaItem = _namaItemController.text.trim();
    final jumlah = double.tryParse(_jumlahController.text.trim()) ?? -1;
    final kategori = _kategoriController.text.trim();
    final keterangan = _keteranganController.text.trim();

    if (namaItem.isEmpty) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Nama pekerjaan wajib diisi',
        type: StatusBannerType.error,
      );
      return;
    }

    if (jumlah < 0) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Jumlah pengeluaran harus diisi dengan benar',
        type: StatusBannerType.error,
      );
      return;
    }

    if (kategori.isEmpty) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Riwayat pengeluaran wajib diisi',
        type: StatusBannerType.error,
      );
      return;
    }

    if (keterangan.isEmpty) {
      StatusBanner.show(
        context,
        title: 'Validasi Gagal',
        message: 'Detail nota wajib diisi',
        type: StatusBannerType.error,
      );
      return;
    }

    context.read<TambahPengeluaranBloc>().add(
      SubmitPengeluaranRequested(
        projectId: widget.projectId,
        namaItem: namaItem,
        kategori: kategori,
        jumlah: jumlah,
        tanggal: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(_selectedDate),
        keterangan: keterangan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TambahPengeluaranBloc(PekerjaanService()),
      child: BlocListener<TambahPengeluaranBloc, TambahPengeluaranState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            StatusBanner.show(
              context,
              title: 'Pengeluaran Gagal',
              message: state.errorMessage!,
              type: StatusBannerType.error,
            );
          }

          if (state.isSuccess && (state.successMessage?.isNotEmpty ?? false)) {
            Navigator.pop(context, state.successMessage);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                const _TambahPengeluaranHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel("Nama Pekerjaan"),
                        const SizedBox(height: 8),
                        _SearchField(
                          controller: _namaItemController,
                          hintText: "Ketik Disini",
                          suffixIcon: Icons.search,
                        ),
                        const SizedBox(height: 20),

                        const _FieldLabel("Masukkan Tanggal"),
                        const SizedBox(height: 8),
                        _DateField(
                          value: DateFormat(
                            'dd MMMM yyyy',
                            'id_ID',
                          ).format(_selectedDate),
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 20),

                        const _FieldLabel("Jumlah"),
                        const SizedBox(height: 8),
                        _SearchField(
                          controller: _jumlahController,
                          hintText: "0",
                          suffixIcon: Icons.payments_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        const _FieldLabel("Riwayat Pengeluaran"),
                        const SizedBox(height: 8),
                        _MultilineSearchField(
                          controller: _kategoriController,
                          hintText: "Ketik Disini",
                        ),
                        const SizedBox(height: 20),

                        const _FieldLabel("Detail Nota"),
                        const SizedBox(height: 8),
                        _MultilineSearchField(
                          controller: _keteranganController,
                          hintText: "Ketik Disini",
                        ),
                        const SizedBox(height: 20),

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
                              const Text(
                                "Upload Bukti Nota",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (_selectedImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_selectedImage!.path),
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                const _UploadBox(),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: OutlinedButton.icon(
                                  onPressed: _pickImage,
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
                                    "Add Photo",
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<
                      TambahPengeluaranBloc,
                      TambahPengeluaranState
                    >(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => _submitPengeluaran(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7944D),
                            disabledBackgroundColor: const Color(0xFFF2B98F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                              : const Text(
                                  "Submit Progress",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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

class _TambahPengeluaranHeader extends StatelessWidget {
  const _TambahPengeluaranHeader();

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
          const Expanded(
            child: Text(
              "Tambah Pengeluaran",
              style: TextStyle(
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData suffixIcon;
  final TextInputType? keyboardType;

  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: Icon(suffixIcon, color: const Color(0xFF9CA3AF)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
        hintStyle: const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFF9CA3AF),
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _MultilineSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _MultilineSearchField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 42),
          child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF5D93E8),
          style: BorderStyle.solid,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: Color(0xFF2563EB), size: 28),
          SizedBox(height: 8),
          Text(
            "Upload",
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
