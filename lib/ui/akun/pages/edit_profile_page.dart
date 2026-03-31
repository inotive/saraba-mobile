import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';

class EditProfileResult {
  final bool success;
  final String title;
  final String message;
  final StatusBannerType bannerType;

  const EditProfileResult({
    required this.success,
    required this.title,
    required this.message,
    required this.bannerType,
  });
}

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? role;
  final String? avatarPath;
  final String? avatarUrl;

  const EditProfilePage({
    super.key,
    this.name,
    this.role,
    this.avatarPath,
    this.avatarUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const List<String> _roleOptions = [
    'Admin',
    'Manajer Keuangan',
    'Super Admin',
    'Senior Accountant',
    'Project Manager',
    'Site Engineer',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  late String _selectedRole;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? 'User';
    _selectedRole = _resolveInitialRole(widget.role);
    _selectedImagePath = widget.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _resolveInitialRole(String? role) {
    if (role != null && _roleOptions.contains(role)) {
      return role;
    }

    if (role != null && role.isNotEmpty) {
      return role;
    }

    return 'Admin';
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImagePath = image.path;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ProfileBloc>().add(
      UpdateProfileSubmitted(
        name: _nameController.text.trim(),
        role: _selectedRole,
        telepon: '',
        alamat: '',
        avatarPath: _selectedImagePath != widget.avatarPath
            ? _selectedImagePath
            : null,
      ),
    );
  }

  ImageProvider? _buildAvatarImage() {
    if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
      return FileImage(File(_selectedImagePath!));
    }

    if (widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty) {
      return NetworkImage(widget.avatarUrl!);
    }

    return null;
  }

  Widget _buildAvatar() {
    final image = _buildAvatarImage();
    if (image != null) {
      return CircleAvatar(radius: 36, backgroundImage: image);
    }

    return const CircleAvatar(
      radius: 36,
      backgroundColor: Color(0xFFF1F3F5),
      child: Icon(Icons.person, color: Color(0xFF9AA0A6), size: 34),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleItems = {
      ..._roleOptions,
      if (_selectedRole.isNotEmpty) _selectedRole,
    }.toList();

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.updateProfileErrorMessage != null) {
          final result = EditProfileResult(
            success: false,
            title: 'Profil Gagal Diperbarui',
            message: state.updateProfileErrorMessage!,
            bannerType: StatusBannerType.error,
          );
          context.read<ProfileBloc>().add(UpdateProfileFeedbackCleared());
          Navigator.pop(context, result);
          return;
        }

        if (state.updateProfileSuccessMessage != null) {
          context.read<ProfileBloc>().add(UpdateProfileFeedbackCleared());
          Navigator.pop(
            context,
            EditProfileResult(
              success: true,
              title: 'Profil Berhasil Diperbarui',
              message: state.updateProfileSuccessMessage!,
              bannerType: StatusBannerType.success,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F7F7),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 0,
            title: const Text(
              'Ubah Profil',
              style: TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9E9E9)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildAvatar()),
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _pickImage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF8A42),
                            side: const BorderSide(color: Color(0xFFFFB382)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                          ),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text(
                            'Ganti Foto',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Nama',
                        style: TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Jabatan',
                        style: TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFFB8B8B8),
                        ),
                        decoration: _inputDecoration(),
                        items: roleItems
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedRole = value;
                          });
                        },
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: state.isUpdatingProfile
                              ? null
                              : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF934D),
                            disabledBackgroundColor: const Color(0xFFFFC299),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isUpdatingProfile
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFF934D)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
