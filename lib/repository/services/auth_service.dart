import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/login_response_model.dart';
import 'package:saraba_mobile/repository/model/mock/auth_service_mock.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const bool useMock =
      false; // For development, delete this when backend is ready
  static const AppLogger _logger = AppLogger('AuthService');

  late final Dio _dio = _buildDio(
    BaseOptions(
      baseUrl: "https://saraba.inotivedev.com/api/v1",
      headers: {"Accept": "application/json"},
    ),
  );

  Dio _buildDio(BaseOptions options) {
    final dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.request(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.response(response);
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.dioError(error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    if (useMock) {
      try {
        _logger.log('Mock login request');
        final response = await AuthServiceMock.login(
          email: email,
          password: password,
        );
        final token = "${response.data.tokenType} ${response.data.token}";
        _logger.log('Mock login success: ${response.message}');

        await _saveUserToHive(_mapLoginUser(response.data));
        await _saveToken(token);
        return response;
      } catch (e) {
        _logger.error('Mock error: $e');
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

        await _saveUserToHive(_mapLoginUser(loginResponse.data));
        await _saveToken(token);
        _logger.log('Login success');

        return loginResponse;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> _saveUserToHive(User user) async {
    final box = Hive.box<User>('userBox');
    await box.put('current_user', user);
  }

  User _mapLoginUser(LoginData data) {
    final karyawan = data.karyawan;

    return User(
      id: data.user.id,
      name: karyawan?.nama.isNotEmpty == true ? karyawan!.nama : data.user.name,
      email: data.user.email,
      role: data.user.role,
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<bool> logout() async {
    if (useMock) {
      try {
        _logger.log('Mock logout request');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        final box = Hive.box<User>('userBox');
        await box.delete('current_user');
        _logger.log('Mock logout success');
        return true; // Just return true for mock logout
      } catch (e) {
        _logger.error('Mock logout error: $e');
      }
    }

    try {
      final token = await getToken();

      final response = await _dio.post(
        "/logout",
        options: Options(headers: {"Authorization": token}),
      );

      _logger.response(response);

      if (response.statusCode == 200 && response.data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        final box = Hive.box<User>('userBox');
        await box.delete('current_user');
        _logger.log('Logout success');

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Dio> getAuthDio() async {
    final token = await getToken();

    return _buildDio(
      BaseOptions(
        baseUrl: "https://saraba.inotivedev.com/api/v1",
        headers: {"Authorization": token ?? "", "Accept": "application/json"},
      ),
    );
  }
}
