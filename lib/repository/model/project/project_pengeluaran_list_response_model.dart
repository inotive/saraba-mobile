class ProjectPengeluaranListResponse {
  final bool success;
  final String message;
  final List<ProjectPengeluaranListItem> data;

  const ProjectPengeluaranListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectPengeluaranListResponse.fromJson(Map<String, dynamic> json) {
    return ProjectPengeluaranListResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProjectPengeluaranListItem.fromJson)
          .toList(),
    );
  }
}

class ProjectPengeluaranListItem {
  final int id;
  final String nomorTransaksi;
  final String kategori;
  final String tanggal;
  final int totalItem;
  final double grandTotal;

  const ProjectPengeluaranListItem({
    required this.id,
    required this.nomorTransaksi,
    required this.kategori,
    required this.tanggal,
    required this.totalItem,
    required this.grandTotal,
  });

  factory ProjectPengeluaranListItem.fromJson(Map<String, dynamic> json) {
    return ProjectPengeluaranListItem(
      id: _parseInt(json['id']),
      nomorTransaksi: (json['nomor_transaksi'] ?? '').toString(),
      kategori: (json['kategori'] ?? '').toString(),
      tanggal: (json['tanggal'] ?? '').toString(),
      totalItem: _parseInt(json['total_item']),
      grandTotal: _parseDouble(json['grand_total']),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}
