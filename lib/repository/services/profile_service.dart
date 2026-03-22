import 'package:hive/hive.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _avatarPathKey = 'current_user_avatar_path';

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
}
