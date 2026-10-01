import 'package:saraba_mobile/repository/model/pagination_model.dart';

/// Respons `GET /pekerjaan`: daftar gabungan proyek dan turnamen.
class PekerjaanListResponse {
  final bool success;
  final String message;
  final PekerjaanListData data;

  PekerjaanListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PekerjaanListResponse.fromJson(Map<String, dynamic> json) {
    return PekerjaanListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PekerjaanListData.fromJson(json['data'] ?? const {}),
    );
  }
}

class PekerjaanListData {
  final List<PekerjaanItem> items;
  final Pagination pagination;

  PekerjaanListData({required this.items, required this.pagination});

  factory PekerjaanListData.fromJson(Map<String, dynamic> json) {
    return PekerjaanListData(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => PekerjaanItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? const {}),
    );
  }
}

class PekerjaanItem {
  /// `proyek` atau `turnamen`
  final String type;
  final int id;
  final String title;
  final int progress;
  final String nilaiProyek;
  final String nilaiPengeluaran;
  final int jumlahPemain;

  PekerjaanItem({
    required this.type,
    required this.id,
    required this.title,
    required this.progress,
    required this.nilaiProyek,
    required this.nilaiPengeluaran,
    required this.jumlahPemain,
  });

  bool get isTurnamen => type == 'turnamen';

  factory PekerjaanItem.fromJson(Map<String, dynamic> json) {
    return PekerjaanItem(
      type: json['type']?.toString() ?? 'proyek',
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      nilaiProyek: json['nilai_proyek']?.toString() ?? '0',
      nilaiPengeluaran: json['nilai_pengeluaran']?.toString() ?? '0',
      jumlahPemain: (json['jumlah_pemain'] as num?)?.toInt() ?? 0,
    );
  }
}
