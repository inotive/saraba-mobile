import 'package:saraba_mobile/repository/model/history_absensi_model.dart';
import 'package:saraba_mobile/repository/model/submit_absensi_response_model.dart';
import 'package:saraba_mobile/repository/model/today_absensi_model.dart';

class AbsensiServiceMock {
  static const bool isSuccess = true; // Toggle this to simulate success/failure

  static Future<SubmitAbsensiResponse> submitAbsensi({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String keterangan,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!isSuccess) {
      throw Exception("Absensi gagal (mock)");
    }

    return SubmitAbsensiResponse.fromJson({
      "status": "success",
      "message": "Check-in berhasil.",
      "data": {
        "id": 1,
        "user_id": "1",
        "proyek_id": null,
        "tanggal": "2026-03-20T00:00:00.000000Z",
        "jam_masuk": "08:30:00",
        "jam_pulang": "",
        "lat_masuk": latitude,
        "long_masuk": longitude,
        "lat_pulang": "",
        "long_pulang": "",
        "foto_masuk": imagePath,
        "foto_pulang": "",
        "status": "hadir",
        "keterangan": keterangan,
        "created_at": "2026-03-20T08:30:00.000000Z",
        "updated_at": "2026-03-20T08:30:00.000000Z",
        "latitude": "",
        "longitude": "",
        "foto_path": "",
        "ip_address": "",
        "device_info": "",
      },
    });
  }

  static Future<TodayAbsensiResponse> fetchTodayAbsensi() async {
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
