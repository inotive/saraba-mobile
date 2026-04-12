import 'package:saraba_mobile/repository/model/absensi/absensi_detail_response_model.dart';
import 'package:dio/dio.dart';
import 'package:saraba_mobile/core/debug/alice_debug.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/history_absensi_model.dart';
import 'package:saraba_mobile/repository/model/mock/absensi_service_mock.dart';
import 'package:saraba_mobile/repository/model/submit_absensi_response_model.dart';
import 'package:saraba_mobile/repository/model/today_absensi_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class AbsensiService {
  static const bool useMock =
      false; // For development, delete this when backend is ready
  static const AppLogger _logger = AppLogger('AbsensiService');

  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://saraba.inotivedev.com/api/v1",
        headers: {"Accept": "application/json"},
      ),
    );

    AliceDebug.attachToDio(dio);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.request(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.response(response);
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.dioError(error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<SubmitAbsensiResponse?> submitAbsensi({
    required String latitude,
    required String longitude,
    required String imagePath,
    required String keterangan,
  }) async {
    if (useMock) {
      try {
        _logger.log('Mock submit absensi request');
        final response = await AbsensiServiceMock.submitAbsensi(
          latitude: latitude,
          longitude: longitude,
          imagePath: imagePath,
          keterangan: keterangan,
        );
        _logger.log('Mock submit absensi success: ${response.message}');
        return response;
      } catch (e) {
        _logger.error('Mock error: $e');
        return null;
      }
    }

    try {
      final token = await AuthService().getToken();

      final formData = FormData.fromMap({
        "proyek_id": "",
        "lat": latitude,
        "long": longitude,
        "keterangan": keterangan,
        "foto": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        "/absensi",
        data: formData,
        options: Options(headers: {"Authorization": token}),
      );

      _logger.log('Submit absensi completed');

      return SubmitAbsensiResponse.fromJson(response.data);
    } catch (e) {
      _logger.error('Unexpected error: $e');
      return null;
    }
  }

  Future<TodayAbsensiResponse?> fetchTodayAbsensi() async {
    if (useMock) {
      _logger.log('Mock get today absensi request');
      final response = await AbsensiServiceMock.fetchTodayAbsensi();
      _logger.log('Mock today absensi response: ${response.data}');
      _logger.log('Mock today absensi success');
      return response;
    }

    try {
      final token = await AuthService().getToken();

      final response = await _dio.get(
        "/absensi/today",
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        _logger.log('Today absensi success');
        return TodayAbsensiResponse.fromJson(response.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<AbsensiDetailResponse?> fetchAbsensiDetail(String absensiId) async {
    try {
      final token = await AuthService().getToken();

      final response = await _dio.get(
        "/absensi/$absensiId",
        options: Options(headers: {"Authorization": token}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        _logger.log('Absensi detail success');
        return AbsensiDetailResponse.fromJson(response.data);
      }

      return null;
    } catch (e) {
      _logger.error('Unexpected error while loading absensi detail: $e');
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
      _logger.log('Mock get history absensi request');
      final response = await AbsensiServiceMock.getHistoryAbsensi(
        startDate: startDate,
        endDate: endDate,
        page: page,
        perPage: perPage,
      );
      _logger.log('Mock history absensi response: ${response.data}');
      _logger.log('Mock history absensi success');
      return response;
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
        _logger.log('History absensi success');
        return HistoryAbsensiResponse.fromJson(response.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
