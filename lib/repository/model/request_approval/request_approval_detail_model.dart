import 'package:saraba_mobile/repository/model/request_approval/request_approval_item.dart';

class RequestApprovalDetailResponse {
  final bool success;
  final RequestApprovalDetail data;

  const RequestApprovalDetailResponse({
    required this.success,
    required this.data,
  });

  factory RequestApprovalDetailResponse.fromJson(Map<String, dynamic> json) {
    return RequestApprovalDetailResponse(
      success: json['success'] == true,
      data: RequestApprovalDetail.fromJson(json['data']),
    );
  }
}

class RequestApprovalDetail {
  final int id;
  final String idPermintaan;
  final String tanggalPermintaan;
  final String createdBy;
  final int totalItem;
  final int grandTotal;
  final String status;
  final String statusLabel;
  final String deskripsi;

  final List<RequestApprovalItem> items;

  const RequestApprovalDetail({
    required this.id,
    required this.idPermintaan,
    required this.tanggalPermintaan,
    required this.createdBy,
    required this.totalItem,
    required this.grandTotal,
    required this.status,
    required this.statusLabel,
    required this.deskripsi,
    required this.items,
  });

  factory RequestApprovalDetail.fromJson(Map<String, dynamic> json) {
    return RequestApprovalDetail(
      id: _parseInt(json['id']),
      idPermintaan: json['id_permintaan'] ?? '',
      tanggalPermintaan: json['tanggal_permintaan'] ?? '',
      createdBy: json['created_by'] ?? '',
      totalItem: _parseInt(json['total_item']),
      grandTotal: _parseInt(json['grand_total']),
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => RequestApprovalItem.fromJson(e))
          .toList(),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
