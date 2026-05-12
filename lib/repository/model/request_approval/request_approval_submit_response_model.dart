class RequestApprovalSubmitResponse {
  final bool success;
  final String message;
  final RequestApprovalSubmitData? data;

  const RequestApprovalSubmitResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RequestApprovalSubmitResponse.fromJson(Map<String, dynamic> json) {
    return RequestApprovalSubmitResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: json['data'] is Map<String, dynamic>
          ? RequestApprovalSubmitData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RequestApprovalSubmitData {
  final int id;
  final int proyekId;
  final String proyekName;
  final String tanggalPermintaan;
  final String deskripsi;
  final String status;
  final String createdBy;
  final int? totalItem;
  final double? grandTotal;

  const RequestApprovalSubmitData({
    required this.id,
    required this.proyekId,
    required this.proyekName,
    required this.tanggalPermintaan,
    required this.deskripsi,
    required this.status,
    required this.createdBy,
    this.totalItem,
    this.grandTotal,
  });

  factory RequestApprovalSubmitData.fromJson(Map<String, dynamic> json) {
    return RequestApprovalSubmitData(
      id: _parseInt(json['id']),
      proyekId: _parseInt(json['proyek_id']),
      proyekName: (json['proyek_name'] ?? '').toString(),
      tanggalPermintaan: (json['tanggal_permintaan'] ?? '').toString(),
      deskripsi: (json['deskripsi'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
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
