class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      data: ProfileData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ProfileData {
  final ProfileUser user;
  final KaryawanProfile? karyawan;

  ProfileData({required this.user, this.karyawan});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: ProfileUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      karyawan: json['karyawan'] is Map<String, dynamic>
          ? KaryawanProfile.fromJson(json['karyawan'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProfileUser {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String? role;
  final String createdAt;

  ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.createdAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      role: json['role'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

class KaryawanProfile {
  final String id;
  final String nama;
  final String email;
  final String telepon;
  final String jabatan;
  final String departemen;
  final String status;
  final String tanggalBergabung;
  final String alamat;

  KaryawanProfile({
    required this.id,
    required this.nama,
    required this.email,
    required this.telepon,
    required this.jabatan,
    required this.departemen,
    required this.status,
    required this.tanggalBergabung,
    required this.alamat,
  });

  factory KaryawanProfile.fromJson(Map<String, dynamic> json) {
    return KaryawanProfile(
      id: json['id'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telepon: json['telepon'] as String? ?? '',
      jabatan: json['jabatan'] as String? ?? '',
      departemen: json['departemen'] as String? ?? '',
      status: json['status'] as String? ?? '',
      tanggalBergabung: json['tanggal_bergabung'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
    );
  }
}
