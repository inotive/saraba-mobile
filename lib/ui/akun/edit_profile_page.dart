import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;
  final String? avatarPath;

  const EditProfilePage({super.key, this.user, this.avatarPath});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const List<String> _roleOptions = [
    'Manajer Keuangan',
    'Super Admin',
    'Senior Accountant',
    'Project Manager',
    'Site Engineer',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _profileService = ProfileService();
  final _picker = ImagePicker();

  late String _selectedRole;
  String? _selectedImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.name ?? 'Rahmad Hidayat';
    _selectedRole = _resolveInitialRole(widget.user?.role);
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

    return _roleOptions.first;
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

    setState(() {
      _isSaving = true;
    });

    await _profileService.updateProfile(
      name: _nameController.text.trim(),
      role: _selectedRole,
    );
    await _profileService.saveAvatarPath(_selectedImagePath);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    Navigator.pop(context, true);
  }

  ImageProvider _buildAvatarImage() {
    if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
      return FileImage(File(_selectedImagePath!));
    }

    return const NetworkImage('https://i.pravatar.cc/150?img=3');
  }

  @override
  Widget build(BuildContext context) {
    final roleItems = {
      ..._roleOptions,
      if (_selectedRole.isNotEmpty) _selectedRole,
    }.toList();

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
                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: _buildAvatarImage(),
                    ),
                  ),
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
                    value: _selectedRole,
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
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF934D),
                        disabledBackgroundColor: const Color(0xFFFFC299),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
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
