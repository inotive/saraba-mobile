import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://saraba.inotivedev.com/api/v1",
      headers: {"Accept": "application/json"},
    ),
  );

  // ================= LOGIN =================
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
          "device_name": "flutter_app",
        },
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final data = response.data["data"];

        final String token = data["token"];
        final String tokenType = data["token_type"];

        // SAVE TOKEN
        await _saveToken("$tokenType $token");

        return data;
      }

      return null;
    } on DioException catch (e) {
      print("Login error: ${e.response?.data}");
      return null;
    }
  }

  // ================= SAVE TOKEN =================
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
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
