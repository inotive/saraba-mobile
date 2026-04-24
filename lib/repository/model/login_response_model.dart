import 'package:saraba_mobile/repository/model/user_model.dart';

class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final User user;
  final LoginKaryawan? karyawan;
  final String token;
  final String tokenType;

  LoginData({
    required this.user,
    required this.karyawan,
    required this.token,
    required this.tokenType,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user']),
      karyawan: json['karyawan'] is Map<String, dynamic>
          ? LoginKaryawan.fromJson(json['karyawan'])
          : null,
      token: json['token'],
      tokenType: json['token_type'],
    );
  }
}

class LoginKaryawan {
  final int id;
  final String nama;
  final String jabatan;
  final String departemen;
  final String status;

  LoginKaryawan({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.departemen,
    required this.status,
  });

  factory LoginKaryawan.fromJson(Map<String, dynamic> json) {
    return LoginKaryawan(
      id: json['id'] as int? ?? 0,
      nama: json['nama'] as String? ?? '',
      jabatan: json['jabatan'] as String? ?? '',
      departemen: json['departemen'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
