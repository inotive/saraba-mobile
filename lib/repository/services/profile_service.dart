import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:saraba_mobile/repository/model/profile_response_model.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _avatarPathKey = 'current_user_avatar_path';

  Future<ProfileResponse?> getProfile() async {
    try {
      final dio = await AuthService().getAuthDio();
      debugPrint('[ProfileService] GET /profile');
      final response = await dio.get('/profile');
      debugPrint(
        '[ProfileService] Response status: ${response.statusCode}',
      );
      debugPrint('[ProfileService] Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final profileResponse = ProfileResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        debugPrint(
          '[ProfileService] Parsed profile: '
          'name=${profileResponse.data.karyawan?.nama.isNotEmpty == true ? profileResponse.data.karyawan!.nama : profileResponse.data.user.name}, '
          'role=${_resolveRole(profileResponse)}, '
          'avatar=${profileResponse.data.user.avatar}',
        );

        await saveCurrentUser(
          User(
            id: profileResponse.data.user.id,
            name: profileResponse.data.karyawan?.nama.isNotEmpty == true
                ? profileResponse.data.karyawan!.nama
                : profileResponse.data.user.name,
            email: profileResponse.data.karyawan?.email.isNotEmpty == true
                ? profileResponse.data.karyawan!.email
                : profileResponse.data.user.email,
            role: _resolveRole(profileResponse),
          ),
        );

        return profileResponse;
      }
      debugPrint('[ProfileService] Profile request was not successful');
    } on DioException catch (e) {
      debugPrint('[ProfileService] Dio error while loading profile: ${e.message}');
      debugPrint('[ProfileService] Dio response: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('[ProfileService] Unexpected error while loading profile: $e');
      return null;
    }

    return null;
  }

  Future<User?> getCurrentUser() async {
    final box = Hive.box<User>('userBox');
    return box.get('current_user');
  }

  Future<void> saveCurrentUser(User user) async {
    final box = Hive.box<User>('userBox');
    await box.put('current_user', user);
  }

  Future<void> updateProfile({
    required String name,
    required String role,
  }) async {
    final currentUser = await getCurrentUser();

    final updatedUser = User(
      id: currentUser?.id ?? 0,
      name: name,
      email: currentUser?.email ?? '',
      role: role,
    );

    await saveCurrentUser(updatedUser);
  }

  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  Future<void> saveAvatarPath(String? path) async {
    final prefs = await SharedPreferences.getInstance();

    if (path == null || path.isEmpty) {
      await prefs.remove(_avatarPathKey);
      return;
    }

    await prefs.setString(_avatarPathKey, path);
  }

  String _resolveRole(ProfileResponse profileResponse) {
    final jabatan = profileResponse.data.karyawan?.jabatan ?? '';
    if (jabatan.isNotEmpty) {
      return jabatan;
    }

    return profileResponse.data.user.role ?? '';
  }
}
