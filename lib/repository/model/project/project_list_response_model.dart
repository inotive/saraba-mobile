import 'package:saraba_mobile/repository/model/pagination_model.dart';

class ProjectListResponse {
  final bool success;
  final String message;
  final ProjectListData data;

  ProjectListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) {
    return ProjectListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProjectListData.fromJson(json['data'] ?? const {}),
    );
  }
}

class ProjectListData {
  final List<ProjectItem> proyeks;
  final Pagination pagination;

  ProjectListData({required this.proyeks, required this.pagination});

  factory ProjectListData.fromJson(Map<String, dynamic> json) {
    return ProjectListData(
      proyeks: (json['proyeks'] as List<dynamic>? ?? const [])
          .map((item) => ProjectItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? const {}),
    );
  }
}

class ProjectItem {
  final int id;
  final String namaProyek;
  final String dinas;
  final String lokasi;
  final String nilaiProyek;
  final String nilaiPengeluaran;
  final int progress;
  final String status;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String deskripsi;

  ProjectItem({
    required this.id,
    required this.namaProyek,
    required this.dinas,
    required this.lokasi,
    required this.nilaiProyek,
    required this.nilaiPengeluaran,
    required this.progress,
    required this.status,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.deskripsi,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'] ?? 0,
      namaProyek: json['nama_proyek'] ?? '',
      dinas: json['dinas'] ?? '',
      lokasi: json['lokasi'] ?? '',
      nilaiProyek: json['nilai_proyek'] ?? '0',
      nilaiPengeluaran: json['nilai_pengeluaran'] ?? '0',
      progress: json['progress'] ?? 0,
      status: json['status'] ?? '',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }
}
