class ProjectRequestResponse {
  final bool success;
  final List<ProjectRequestData> data;

  const ProjectRequestResponse({required this.success, required this.data});

  factory ProjectRequestResponse.fromJson(Map<String, dynamic> json) {
    return ProjectRequestResponse(
      success: json['success'] == true,
      data: (json['data'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProjectRequestData.fromJson)
          .toList(),
    );
  }
}

class ProjectRequestData {
  final int id;
  final String idPermintaan;
  final String tanggalPermintaan;
  final String deskripsi;
  final String status;
  final String proyekId;
  final String proyekName;
  final String createdAt;
  final String createdBy;
  final int? totalItem;
  final double? grandTotal;

  const ProjectRequestData({
    required this.id,
    required this.idPermintaan,
    required this.tanggalPermintaan,
    required this.deskripsi,
    required this.status,
    required this.proyekId,
    required this.proyekName,
    required this.createdAt,
    required this.createdBy,
    this.totalItem,
    this.grandTotal,
  });

  factory ProjectRequestData.fromJson(Map<String, dynamic> json) {
    return ProjectRequestData(
      id: _parseInt(json['id']),
      idPermintaan: (json['id_permintaan'] ?? '').toString(),
      tanggalPermintaan: (json['tanggal_permintaan'] ?? '').toString(),
      deskripsi: (json['deskripsi'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      proyekId: (json['proyek_id'] ?? '').toString(),
      proyekName: (json['proyek_name'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      createdBy: (json['created_by'] ?? '').toString(),
      totalItem: _parseInt(json['total_item']),
      grandTotal: double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
