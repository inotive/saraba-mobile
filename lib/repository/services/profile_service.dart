import 'package:dio/dio.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/profile/change_password_response_model.dart';
import 'package:hive/hive.dart';
import 'package:saraba_mobile/repository/model/profile/profile_response_model.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _avatarPathKey = 'current_user_avatar_path';
  static const AppLogger _logger = AppLogger('ProfileService');

  Future<ProfileResponse?> getProfile() async {
    if (AuthService.useMock) {
      return _getMockProfile();
    }

    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.get('/profile');
      _logger.response(response);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final profileResponse = ProfileResponse.fromJson(
          response.data as Map<String, dynamic>,
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
            role: profileResponse.data.user.role ?? '',
          ),
        );

        _logger.log('Profile loaded successfully');

        return profileResponse;
      }
      _logger.error('Profile request was not successful');
    } on DioException catch (e) {
      _logger.dioError(e);
      return null;
    } catch (e) {
      _logger.error('Unexpected error while loading profile: $e');
      return null;
    }

    return null;
  }

  Future<ProfileResponse?> _getMockProfile() async {
    try {
      final currentUser = await getCurrentUser();
      final user = currentUser ??
          User(
            id: 1,
            name: 'Staff Lapangan',
            email: 'admin@gmail.com',
            role: 'Staff',
          );

      final profile = ProfileResponse.fromJson({
        'success': true,
        'message': 'Mock profile loaded',
        'data': {
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'avatar': '',
            'role': user.role,
            'created_at': '',
          },
          'karyawan': {
            'id': user.id,
            'nama': user.name,
            'email': user.email,
            'telepon': '',
            'jabatan': 'Pelaksana',
            'departemen': 'IT',
            'status': 'aktif',
            'tanggal_bergabung': '',
            'alamat': '',
          },
        },
      });

      await saveCurrentUser(
        User(
          id: profile.data.user.id,
          name: profile.data.karyawan?.nama.isNotEmpty == true
              ? profile.data.karyawan!.nama
              : profile.data.user.name,
          email: profile.data.user.email,
          role: profile.data.user.role ?? '',
        ),
      );

      _logger.log('Mock profile loaded successfully');
      return profile;
    } catch (e) {
      _logger.error('Unexpected error while loading mock profile: $e');
      return null;
    }
  }

  Future<ChangePasswordResponse?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.post(
        '/profile/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      _logger.response(response);

      final actionResponse = ChangePasswordResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (actionResponse.success) {
        _logger.log('Change password success');
        return actionResponse;
      }

      _logger.error('Change password request was not successful');
      return actionResponse;
    } on DioException catch (e) {
      _logger.dioError(e);
      return ChangePasswordResponse(
        success: false,
        message:
            (e.response?.data is Map<String, dynamic>)
                ? (e.response?.data['message'] as String? ??
                      'Gagal mengubah password')
                : 'Gagal mengubah password',
      );
    } catch (e) {
      _logger.error('Unexpected error while changing password: $e');
      return ChangePasswordResponse(
        success: false,
        message: 'Gagal mengubah password',
      );
    }
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
    String telepon = '',
    String alamat = '',
    String? avatarPath,
  }) async {
    final currentUser = await getCurrentUser();

    try {
      final dio = await AuthService().getAuthDio();
      final formData = FormData.fromMap({
        'name': name,
        'telepon': telepon,
        'alamat': alamat,
        if (avatarPath != null && avatarPath.isNotEmpty)
          'avatar': await MultipartFile.fromFile(avatarPath),
      });

      final response = await dio.post('/profile', data: formData);
      _logger.response(response);

      final profileResponse = ProfileResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (!profileResponse.success) {
        _logger.error('Profile update request was not successful');
        return;
      }

      await saveCurrentUser(
        User(
          id: profileResponse.data.user.id,
          name: profileResponse.data.karyawan?.nama.isNotEmpty == true
              ? profileResponse.data.karyawan!.nama
              : profileResponse.data.user.name,
          email: profileResponse.data.user.email,
          role:
              profileResponse.data.user.role ??
              currentUser?.role ??
              role,
        ),
      );

      if (avatarPath != null && avatarPath.isNotEmpty) {
        await saveAvatarPath(null);
      }

      _logger.log('Profile updated successfully');
      return;
    } on DioException catch (e) {
      _logger.dioError(e);
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error while updating profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfileLocally({
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
}
