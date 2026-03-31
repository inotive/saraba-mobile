import 'package:saraba_mobile/repository/model/pagination_model.dart';

class ProjectProfitResponse {
  final bool success;
  final String message;
  final ProjectProfitSummary summary;
  final List<ProjectProfitItem> data;
  final Pagination pagination;

  ProjectProfitResponse({
    required this.success,
    required this.message,
    required this.summary,
    required this.data,
    required this.pagination,
  });

  factory ProjectProfitResponse.fromJson(Map<String, dynamic> json) {
    return ProjectProfitResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      summary: ProjectProfitSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      data: (json['data'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProjectProfitItem.fromJson)
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ProjectProfitSummary {
  final int totalProyek;
  final double totalNilaiProyek;
  final double totalPengeluaran;
  final double totalProfit;

  ProjectProfitSummary({
    required this.totalProyek,
    required this.totalNilaiProyek,
    required this.totalPengeluaran,
    required this.totalProfit,
  });

  factory ProjectProfitSummary.fromJson(Map<String, dynamic> json) {
    return ProjectProfitSummary(
      totalProyek: _parseInt(json['total_proyek']),
      totalNilaiProyek: _parseDouble(json['total_nilai_proyek']),
      totalPengeluaran: _parseDouble(json['total_pengeluaran']),
      totalProfit: _parseDouble(json['total_profit']),
    );
  }
}

class ProjectProfitItem {
  final int id;
  final String namaProyek;
  final double nilaiProyek;
  final double nilaiPengeluaran;
  final double keuntungan;
  final String status;
  final int progress;

  ProjectProfitItem({
    required this.id,
    required this.namaProyek,
    required this.nilaiProyek,
    required this.nilaiPengeluaran,
    required this.keuntungan,
    required this.status,
    required this.progress,
  });

  factory ProjectProfitItem.fromJson(Map<String, dynamic> json) {
    return ProjectProfitItem(
      id: _parseInt(json['id']),
      namaProyek: json['nama_proyek'] as String? ?? '',
      nilaiProyek: _parseDouble(json['nilai_proyek']),
      nilaiPengeluaran: _parseDouble(json['nilai_pengeluaran']),
      keuntungan: _parseDouble(json['keuntungan']),
      status: json['status'] as String? ?? '',
      progress: _parseInt(json['progress']),
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _parseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
