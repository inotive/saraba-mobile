import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';
import 'package:saraba_mobile/ui/akun/change_password_page.dart';
import 'package:saraba_mobile/ui/akun/edit_profile_page.dart';
import 'package:saraba_mobile/ui/akun/project_profit_page.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_bloc.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_event.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_state.dart';
import 'package:saraba_mobile/ui/login/login_page.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  Future<void> _openEditProfile(
    BuildContext context,
    ProfileState profile,
  ) async {
    final profileBloc = context.read<ProfileBloc>();
    final isUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: profileBloc,
          child: EditProfilePage(
            name: profile.displayName,
            role: profile.displayRole,
            avatarPath: profile.avatarPath,
            avatarUrl: profile.remoteAvatar,
          ),
        ),
      ),
    );

    if (isUpdated != true || !context.mounted) {
      return;
    }

    context.read<ProfileBloc>().add(ProfileRequested());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
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
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.isError && state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.isLoading) const SizedBox(height: 16),
                  _profileCard(context, state),
                  const SizedBox(height: 16),
                  _menuCard(context),
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

  Widget _profileCard(BuildContext context, ProfileState profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileAvatar(profile),
              const SizedBox(height: 8),
              Text(
                profile.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.displayRole,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => _openEditProfile(context, profile),
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

  Widget _buildProfileAvatar(ProfileState profile) {
    if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: FileImage(File(profile.avatarPath!)),
      );
    }

    if (profile.remoteAvatar.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profile.remoteAvatar),
      );
    }

    return const CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xFFF1F3F5),
      child: Icon(Icons.person, color: Color(0xFF9AA0A6), size: 30),
    );
  }

  Widget _menuCard(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.person,
            title: 'Personal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProjectProfitPage()),
              );
            },
          ),
          _menuItem(
            icon: Icons.build,
            title: 'General',
            onTap: () {
              final profileBloc = context.read<ProfileBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: profileBloc,
                    child: const ChangePasswordPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
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
