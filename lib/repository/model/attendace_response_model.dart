class AttendanceResponse {
  final bool success;
  final String message;
  final AttendanceData data;

  AttendanceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'],
      message: json['message'],
      data: AttendanceData.fromJson(json['data']),
    );
  }
}

class AttendanceData {
  final Absensi absensi;
  final Karyawan karyawan;

  AttendanceData({required this.absensi, required this.karyawan});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      absensi: Absensi.fromJson(json['absensi']),
      karyawan: Karyawan.fromJson(json['karyawan']),
    );
  }
}

class Absensi {
  final dynamic id;
  final String tanggal;
  final String jamMasuk;
  final String? jamKeluar;
  final String? durasiKerja;
  final String latitude;
  final String longitude;
  final String? fotoUrl;

  Absensi({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    this.jamKeluar,
    this.durasiKerja,
    required this.latitude,
    required this.longitude,
    this.fotoUrl,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      id: json['id'],
      tanggal: json['tanggal'] ?? '',
      jamMasuk: json['jam_masuk'] ?? '',
      jamKeluar: json['jam_keluar'],
      durasiKerja: json['durasi_kerja'],
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      fotoUrl: json['foto_url'],
    );
  }
}

class Karyawan {
  final dynamic id;
  final String nama;
  final String jabatan;

  Karyawan({required this.id, required this.nama, required this.jabatan});

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id: json['id'],
      nama: json['nama'] ?? '',
      jabatan: json['jabatan'] ?? '',
    );
  }
}
