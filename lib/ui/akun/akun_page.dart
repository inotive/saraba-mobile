import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:saraba_mobile/ui/akun/edit_profile_page.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_bloc.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_event.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_state.dart';
import 'package:saraba_mobile/ui/login/login_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final ProfileService _profileService = ProfileService();
  late Future<_ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<_ProfileData> _loadProfile() async {
    final user = await _profileService.getCurrentUser();
    final avatarPath = await _profileService.getAvatarPath();

    return _ProfileData(user: user, avatarPath: avatarPath);
  }

  Future<void> _openEditProfile(_ProfileData profile) async {
    final isUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          user: profile.user,
          avatarPath: profile.avatarPath,
        ),
      ),
    );

    if (isUpdated != true) {
      return;
    }

    setState(() {
      _profileFuture = _loadProfile();
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Akun')),
        body: FutureBuilder<_ProfileData>(
          future: _profileFuture,
          builder: (context, snapshot) {
            final profile = snapshot.data ?? const _ProfileData();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileCard(profile),
                  const SizedBox(height: 16),
                  _menuCard(),
                  const SizedBox(height: 16),
                  _logoutButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _profileCard(_ProfileData profile) {
    final user = profile.user;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _buildProfileImage(profile.avatarPath),
              ),
              const SizedBox(height: 8),
              Text(
                user?.name ?? 'Rahmad Hidayat',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                user?.role ?? 'Manajer Keuangan',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => _openEditProfile(profile),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Edit', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildProfileImage(String? avatarPath) {
    if (avatarPath != null && avatarPath.isNotEmpty) {
      return FileImage(File(avatarPath));
    }

    return const NetworkImage('https://i.pravatar.cc/150?img=3');
  }

  Widget _menuCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _menuItem(Icons.person, 'Personal'),
          _menuItem(Icons.build, 'General'),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Keluar', style: TextStyle(color: Colors.red)),
        onTap: () {
          context.read<AuthBloc>().add(LogoutRequested());
        },
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _ProfileData {
  final User? user;
  final String? avatarPath;

  const _ProfileData({this.user, this.avatarPath});
}
