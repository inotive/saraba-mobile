class ProjectRequestDetailResponse {
  final bool success;
  final ProjectRequestDetailData data;

  ProjectRequestDetailResponse({required this.success, required this.data});

  factory ProjectRequestDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProjectRequestDetailResponse(
      success: json['success'],
      data: ProjectRequestDetailData.fromJson(json['data']),
    );
  }
}

class ProjectRequestDetailData {
  final List<ProjectRequestItemDetail> items;

  ProjectRequestDetailData({required this.items});

  factory ProjectRequestDetailData.fromJson(Map<String, dynamic> json) {
    return ProjectRequestDetailData(
      items: (json['items'] as List)
          .map((e) => ProjectRequestItemDetail.fromJson(e))
          .toList(),
    );
  }
}

class ProjectRequestItemDetail {
  final String namaItem;
  final int qty;
  final int hargaSatuan;
  final int total;

  ProjectRequestItemDetail({
    required this.namaItem,
    required this.qty,
    required this.hargaSatuan,
    required this.total,
  });

  factory ProjectRequestItemDetail.fromJson(Map<String, dynamic> json) {
    return ProjectRequestItemDetail(
      namaItem: json['nama_item'],
      qty: json['qty'],
      hargaSatuan: json['harga_satuan'],
      total: json['total'],
    );
  }
}
