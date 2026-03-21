import 'package:saraba_mobile/repository/model/attendace_response_model.dart';
import 'package:saraba_mobile/repository/model/history_absensi_model.dart';
import 'package:saraba_mobile/repository/model/today_absensi_model.dart';

class AbsensiServiceMock {
  static const bool isSuccess = true; // Toggle this to simulate success/failure

  static Future<AttendanceResponse> clockIn({
    required String latitude,
    required String longitude,
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!isSuccess) {
      throw Exception("Clock in gagal (mock)");
    }

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

    if (!isSuccess) {
      throw Exception("Clock out gagal (mock)");
    }

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

  static Future<TodayAbsensiResponse> getTodayAbsensi() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!isSuccess) {
      throw Exception("Clock in gagal (mock)");
    }

    return TodayAbsensiResponse.fromJson({
      "success": true,
      "data": {
        "today": "2026-03-21",
        "is_clocked_in": true,
        "is_clocked_out": false,
        "absensi": {
          "id": "1",
          "jam_masuk": "08:42:10",
          "jam_keluar": "",
          "durasi_kerja": "4 jam 12 menit",
          "status": "Masuk",
        },
      },
    });
  }

  static Future<HistoryAbsensiResponse> getHistoryAbsensi({
    required String startDate,
    required String endDate,
    required int page,
    required int perPage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!isSuccess) {
      throw Exception("Clock in gagal (mock)");
    }

    final allItems = List.generate(25, (index) {
      final day = 31 - index;
      final status = index % 5 == 0
          ? "Ijin"
          : index % 7 == 0
          ? "Sakit"
          : "Masuk";

      final note = status == "Masuk" ? "On Time" : "-";

      return {
        "id": "${index + 1}",
        "tanggal": "2026-03-${day.toString().padLeft(2, '0')}",
        "jam_masuk": status == "Masuk" ? "08:42:10" : "",
        "jam_keluar": status == "Masuk" ? "17:00:00" : "",
        "durasi_kerja": status == "Masuk" ? "8 jam 18 menit" : "",
        "status": status,
        "keterangan": note,
      };
    });

    final startIndex = (page - 1) * perPage;
    final endIndex = (startIndex + perPage).clamp(0, allItems.length);
    final pagedItems = allItems.sublist(startIndex, endIndex);

    return HistoryAbsensiResponse.fromJson({
      "success": true,
      "data": {
        "absensis": pagedItems,
        "pagination": {
          "current_page": page,
          "last_page": (allItems.length / perPage).ceil(),
          "per_page": perPage,
          "total": allItems.length,
        },
      },
    });
  }
}
