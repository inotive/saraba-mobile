import 'package:saraba_mobile/repository/model/login_response_model.dart';

class AuthServiceMock {
  static const bool isSuccess = true; // Toggle this to simulate success/failure

  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!isSuccess) {
      throw Exception("Login gagal (mock)");
    }

    return LoginResponse.fromJson({
      "success": true,
      "message": "Login berhasil",
      "data": {
        "user": {
          "id": 1,
          "name": "Staff Lapangan",
          "email": "admin@gmail.com",
          "role": "Staff",
        },
        "karyawan": {
          "id": 1,
          "nama": "Staff Lapangan",
          "jabatan": "Pelaksana",
          "departemen": "IT",
          "status": "aktif",
        },
        "token": "6|WxcXfnEwPjsOq6XK9YU0tEN8LfwFz1kzoL1eKU9M8ca37d75",
        "token_type": "Bearer",
      },
    });
  }
}
