import 'package:dio/dio.dart';
import 'package:saraba_mobile/repository/model/attendace_response_model.dart';
import 'package:saraba_mobile/repository/model/history_absensi_model.dart';
import 'package:saraba_mobile/repository/model/mock/absensi_service_mock.dart';
import 'package:saraba_mobile/repository/model/today_absensi_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class AbsensiService {
  static const bool useMock =
      true; // For development, delete this when backend is ready

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://saraba.inotivedev.com/api/v1",
      headers: {"Accept": "application/json"},
    ),
  );

  Future<AttendanceResponse?> clockIn({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String deviceInfo,
  }) async {
    if (useMock) {
      try {
        return await AbsensiServiceMock.clockIn(
          latitude: latitude,
          longitude: longitude,
          imagePath: imagePath,
        );
      } catch (e) {
        print("Mock error: $e");
        return null;
      }
    }

    try {
      final token = await AuthService().getToken();

      final formData = FormData.fromMap({
        "latitude": latitude,
        "longitude": longitude,
        "device_info": deviceInfo,
        "foto": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        "/absensi/clock-in",
        data: formData,
        options: Options(headers: {"Authorization": token}),
      );

      return AttendanceResponse.fromJson(response.data);
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<AttendanceResponse?> clockOut({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String deviceInfo,
  }) async {
    if (useMock) {
      try {
        return await AbsensiServiceMock.clockOut(
          latitude: latitude,
          longitude: longitude,
          imagePath: imagePath,
        );
      } catch (e) {
        print("Mock error: $e");
        return null;
      }
    }

    try {
      final token = await AuthService().getToken();

      final formData = FormData.fromMap({
        "latitude": latitude,
        "longitude": longitude,
        "device_info": deviceInfo,
        "foto": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        "/absensi/clock-out",
        data: formData,
        options: Options(headers: {"Authorization": token}),
      );

      return AttendanceResponse.fromJson(response.data);
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<TodayAbsensiResponse?> getTodayAbsensi() async {
    if (useMock) {
      return AbsensiServiceMock.getTodayAbsensi();
    }

    try {
      final token = await AuthService().getToken();

      final response = await _dio.get(
        "/absensi/today",
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return TodayAbsensiResponse.fromJson(response.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<HistoryAbsensiResponse?> getHistoryAbsensi({
    required String startDate,
    required String endDate,
    required int page,
    required int perPage,
  }) async {
    if (useMock) {
      return AbsensiServiceMock.getHistoryAbsensi(
        startDate: startDate,
        endDate: endDate,
        page: page,
        perPage: perPage,
      );
    }

    try {
      final token = await AuthService().getToken();

      final response = await _dio.get(
        "/absensi/history",
        queryParameters: {
          "start_date": startDate,
          "end_date": endDate,
          "page": page,
          "per_page": perPage,
        },
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return HistoryAbsensiResponse.fromJson(response.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
