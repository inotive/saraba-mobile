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
          "name": "Super Admin",
          "email": "admin@gmail.com",
          "role": "Super Admin",
        },
        "karyawan": {
          "id": 1,
          "nama": "Super Admin",
          "jabatan": "Administrator",
          "departemen": "IT",
          "status": "aktif",
        },
        "token": "7|Tbwl6khAtmufKKH99MkwgBDJCrK7inTz67GiK1VJ60a28f3e",
        "token_type": "Bearer",
      },
    });
  }
}
