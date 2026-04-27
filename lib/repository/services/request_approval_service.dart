import 'package:dio/dio.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_detail_model.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_model.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_submit_response_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class RequestApprovalService {
  static const AppLogger _logger = AppLogger('RequestApprovalService');

  Future<RequestApprovalResponse?> fetchRequestApproval({
    String? status,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();

      final response = await dio.get(
        '/permintaans',
        queryParameters: {'status': ?status},
      );

      if (response.statusCode == 200) {
        return RequestApprovalResponse.fromJson(response.data);
      }
    } catch (e) {
      _logger.error(e.toString());
    }

    return null;
  }

  Future<RequestApprovalDetailResponse?> fetchDetailRequestApproval(
    String permintaanId,
  ) async {
    try {
      final dio = await AuthService().getAuthDio();

      final response = await dio.get('/permintaans/$permintaanId');

      if (response.statusCode == 200) {
        return RequestApprovalDetailResponse.fromJson(response.data);
      }
    } catch (e) {
      _logger.error(e.toString());
    }

    return null;
  }

  Future<RequestApprovalSubmitResponse?> approveRequestApproval({
    required String permintaanId,
    required String tanggalPermintaan,
    required String deskripsi,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.post(
        '/permintaans/$permintaanId/approve',
        data: {'tanggal_permintaan': tanggalPermintaan, 'deskripsi': deskripsi},
      );

      _logger.response(response);

      if (response.data is Map<String, dynamic>) {
        return RequestApprovalSubmitResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      _logger.error('Approve request approval was not successful');
    } on DioException catch (e) {
      _logger.dioError(e);

      if (e.response?.data is Map<String, dynamic>) {
        return RequestApprovalSubmitResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _logger.error('Unexpected error while approving request approval: $e');
    }

    return null;
  }

  Future<RequestApprovalSubmitResponse?> rejectRequestApproval({
    required String projectId,
    required String requestId,
    required String tanggalPermintaan,
    required String deskripsi,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.put(
        '/permintaans/$requestId/reject',
        data: {'tanggal_permintaan': tanggalPermintaan, 'deskripsi': deskripsi},
      );

      _logger.response(response);

      if (response.data is Map<String, dynamic>) {
        return RequestApprovalSubmitResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      _logger.error('Reject request approval was not successful');
    } on DioException catch (e) {
      _logger.dioError(e);

      if (e.response?.data is Map<String, dynamic>) {
        return RequestApprovalSubmitResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _logger.error('Unexpected error while rejecting request approval: $e');
    }

    return null;
  }
}
