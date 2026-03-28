import 'package:intl/intl.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/project/project_list_response_model.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';

class PekerjaanService {
  static const AppLogger _logger = AppLogger('PekerjaanService');

  Future<ProjectListResponse?> fetchProyeks({int page = 1}) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.get(
        '/proyeks',
        queryParameters: {'page': page},
      );

      _logger.response(response);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return ProjectListResponse.fromJson(response.data);
      }

      _logger.error('Project list request was not successful');
    } catch (e) {
      _logger.error('Unexpected error while loading proyeks: $e');
    }

    return null;
  }

  List<ProjectModel> mapToProjectModels(List<ProjectItem> items) {
    return items
        .map(
          (item) => ProjectModel(
            id: item.id.toString(),
            title: item.namaProyek,
            progress: (item.progress / 100).clamp(0.0, 1.0),
            nilai: _formatCurrency(item.nilaiProyek),
            pengeluaran: _formatCurrency(item.nilaiPengeluaran),
          ),
        )
        .toList();
  }

  String _formatCurrency(String rawValue) {
    final parsedValue = double.tryParse(rawValue) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(parsedValue);
  }
}
