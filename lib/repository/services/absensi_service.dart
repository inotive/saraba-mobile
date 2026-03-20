import 'package:dio/dio.dart';
import 'package:saraba_mobile/repository/model/attendace_response_model.dart';
import 'package:saraba_mobile/repository/model/mock/absensi_service_mock.dart';
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
        return await AbsensiMock.clockIn(
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
        return await AbsensiMock.clockOut(
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
}
