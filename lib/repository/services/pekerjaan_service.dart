import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:saraba_mobile/core/utils/app_logger.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/model/project/project_list_response_model.dart';
import 'package:saraba_mobile/repository/model/project/submit_pengeluaran_response_model.dart';
import 'package:saraba_mobile/repository/model/project/submit_progress_response_model.dart';
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

  Future<ProjectDetailResponse?> fetchProyekDetail(String proyekId) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.get('/proyeks/$proyekId');

      _logger.response(response);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return ProjectDetailResponse.fromJson(response.data);
      }

      _logger.error('Project detail request was not successful');
    } catch (e) {
      _logger.error('Unexpected error while loading proyek detail: $e');
    }

    return null;
  }

  Future<SubmitProgressResponse?> submitProgressLog({
    required String projectId,
    required String judul,
    required int progressPersen,
    required String tanggal,
    required String catatan,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.post(
        '/proyeks/$projectId/progress-logs',
        data: {
          'judul': judul,
          'progress_persen': progressPersen,
          'tanggal': tanggal,
          'catatan': catatan,
        },
      );

      _logger.response(response);

      if (response.data is Map<String, dynamic>) {
        return SubmitProgressResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      _logger.error('Submit progress request was not successful');
    } on DioException catch (e) {
      _logger.dioError(e);

      if (e.response?.data is Map<String, dynamic>) {
        return SubmitProgressResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _logger.error('Unexpected error while submitting progress: $e');
    }

    return null;
  }

  Future<SubmitPengeluaranResponse?> submitPengeluaran({
    required String projectId,
    required String namaItem,
    required String kategori,
    required double jumlah,
    required String tanggal,
    required String keterangan,
  }) async {
    try {
      final dio = await AuthService().getAuthDio();
      final response = await dio.post(
        '/proyeks/$projectId/pengeluaran',
        data: {
          'nama_item': namaItem,
          'kategori': kategori,
          'jumlah': jumlah,
          'tanggal': tanggal,
          'keterangan': keterangan,
        },
      );

      _logger.response(response);

      if (response.data is Map<String, dynamic>) {
        return SubmitPengeluaranResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      _logger.error('Submit pengeluaran request was not successful');
    } on DioException catch (e) {
      _logger.dioError(e);

      if (e.response?.data is Map<String, dynamic>) {
        return SubmitPengeluaranResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _logger.error('Unexpected error while submitting pengeluaran: $e');
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
