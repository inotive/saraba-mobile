import 'package:saraba_mobile/repository/model/attendace_response_model.dart';

class AbsensiMock {
  static Future<AttendanceResponse> clockIn({
    required String latitude,
    required String longitude,
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return AttendanceResponse.fromJson({
      "success": true,
      "message": "Clock In berhasil",
      "data": {
        "absensi": {
          "id": 1,
          "tanggal": "2026-03-20",
          "jam_masuk": "08:30",
          "latitude": latitude,
          "longitude": longitude,
          "foto_url": imagePath,
        },
        "karyawan": {"id": "1", "nama": "Rahmad Hidayat", "jabatan": "Manager"},
      },
    });
  }

  static Future<AttendanceResponse> clockOut({
    required String latitude,
    required String longitude,
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return AttendanceResponse.fromJson({
      "success": true,
      "message": "Clock Out berhasil",
      "data": {
        "absensi": {
          "id": 1,
          "tanggal": "2026-03-20",
          "jam_masuk": "08:30",
          "jam_keluar": "17:10",
          "durasi_kerja": "8 jam",
          "latitude": latitude,
          "longitude": longitude,
        },
        "karyawan": {"id": "1", "nama": "Rahmad Hidayat", "jabatan": "Manager"},
      },
    });
  }
}
