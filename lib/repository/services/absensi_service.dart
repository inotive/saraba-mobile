import 'package:dio/dio.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class AbsensiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://saraba.inotivedev.com/api/v1",
      headers: {"Accept": "application/json"},
    ),
  );

  Future<bool> clockIn({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String deviceInfo,
  }) async {
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

      return response.data["success"] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clockOut({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String deviceInfo,
  }) async {
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

      return response.data["success"] == true;
    } catch (e) {
      return false;
    }
  }
}
