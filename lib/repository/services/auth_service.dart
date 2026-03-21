import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:saraba_mobile/repository/model/login_response_model.dart';
import 'package:saraba_mobile/repository/model/mock/auth_service_mock.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const bool useMock =
      true; // For development, delete this when backend is ready

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
    if (useMock) {
      try {
        final response = await AuthServiceMock.login(
          email: email,
          password: password,
        );
        final token = "${response.data.tokenType} ${response.data.token}";

        await _saveUserToHive(response.data.user);
        await _saveToken(token);
        return response;
      } catch (e) {
        print("Mock error: $e");
        return null;
      }
    }

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
  Future<bool> logout() async {
    if (useMock) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        final box = Hive.box<User>('userBox');
        await box.delete('current_user');
        return true; // Just return true for mock logout
      } catch (e) {
        print("Mock logout error: $e");
      }
    }

    try {
      final token = await getToken();

      final response = await _dio.post(
        "/logout",
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        final box = Hive.box<User>('userBox');
        await box.delete('current_user');

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
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
