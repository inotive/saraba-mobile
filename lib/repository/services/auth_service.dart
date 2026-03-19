import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:saraba_mobile/repository/model/login_response_model.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://saraba.inotivedev.com/api/v1",
      headers: {"Accept": "application/json"},
    ),
  );

  // ================= LOGIN =================
  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
          "device_name": "saraba_app",
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        final token =
            "${loginResponse.data.tokenType} ${loginResponse.data.token}";

        await _saveUserToHive(loginResponse.data.user);
        await _saveToken(token);

        return loginResponse;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ================= SAVE TOKEN =================
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> _saveUserToHive(User user) async {
    final box = Hive.box<User>('userBox');
    await box.put('current_user', user);
  }

  // ================= GET TOKEN =================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  // ================= AUTH DIO =================
  Future<Dio> getAuthDio() async {
    final token = await getToken();

    return Dio(
      BaseOptions(
        baseUrl: "https://saraba.inotivedev.com/api/v1",
        headers: {"Authorization": token ?? "", "Accept": "application/json"},
      ),
    );
  }
}
