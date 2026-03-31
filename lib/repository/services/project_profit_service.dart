import 'package:dio/dio.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/project_profit/project_profit_response_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class ProjectProfitService {
  static const AppLogger _logger = AppLogger('ProjectProfitService');

  Future<ProjectProfitResponse?> fetchProjectProfits({int page = 1}) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.get(
        '/proyeks/keuntungan',
        queryParameters: {'page': page},
      );
      _logger.response(response);

      final projectProfitResponse = ProjectProfitResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (projectProfitResponse.success) {
        return projectProfitResponse;
      }

      _logger.error('Project profit request was not successful');
      return projectProfitResponse;
    } on DioException catch (e) {
      _logger.dioError(e);
      return null;
    } catch (e) {
      _logger.error('Unexpected error while loading project profits: $e');
      return null;
    }
  }
}
