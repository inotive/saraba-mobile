class RequestApprovalResponse {
  final bool success;
  final List<RequestApprovalData> data;

  const RequestApprovalResponse({required this.success, required this.data});

  factory RequestApprovalResponse.fromJson(Map<String, dynamic> json) {
    return RequestApprovalResponse(
      success: json['success'] == true,
      data: (json['data'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(RequestApprovalData.fromJson)
          .toList(),
    );
  }
}

class RequestApprovalData {
  final int id;
  final String idPermintaan;
  final String tanggalPermintaan;
  final String createdBy;
  final int totalItem;
  final int grandTotal;
  final String status;
  final String statusLabel;
  final int proyekId;
  final String proyekName;
  final String createdAt;

  const RequestApprovalData({
    required this.id,
    required this.idPermintaan,
    required this.tanggalPermintaan,
    required this.createdBy,
    required this.totalItem,
    required this.grandTotal,
    required this.status,
    required this.statusLabel,
    required this.proyekId,
    required this.proyekName,
    required this.createdAt,
  });

  factory RequestApprovalData.fromJson(Map<String, dynamic> json) {
    return RequestApprovalData(
      id: _parseInt(json['id']),
      idPermintaan: json['id_permintaan'] ?? '',
      tanggalPermintaan: json['tanggal_permintaan'] ?? '',
      createdBy: json['created_by'] ?? '',
      totalItem: _parseInt(json['total_item']),
      grandTotal: _parseInt(json['grand_total']),
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      proyekId: _parseInt(json['proyek_id']),
      proyekName: json['proyek_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
