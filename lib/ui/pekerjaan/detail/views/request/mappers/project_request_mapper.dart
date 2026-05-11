import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/mappers/request_category_extension.dart';

import '../models/project_request_item.dart';
import '../models/request_status.dart';
import '../utils/request_date_parser.dart';

import 'package:saraba_mobile/repository/model/project/project_request_response_model.dart';
import 'package:saraba_mobile/repository/model/project/project_request_submit_response_model.dart';

class ProjectRequestMapper {
  static ProjectRequestItem fromResponse(ProjectRequestData item) {
    return ProjectRequestItem(
      requestId: item.id.toString(),
      displayId: item.idPermintaan.toString(),
      createdBy: item.createdBy.isNotEmpty ? item.createdBy : '-',
      requestDate:
          RequestDateParser.parse(item.tanggalPermintaan) ?? DateTime.now(),
      status: _mapStatus(item.status),
      requestText: item.deskripsi,
      totalItem: item.totalItem ?? 0,
      grandTotal: item.grandTotal ?? 0,
      category: requestCategoryFromString(item.kategoriRequest),
      // items: (item.items ?? []).map(ProjectRequestDetailItem.fromJson).toList(),
    );
  }

  static ProjectRequestItem fromSubmit(ProjectRequestSubmitData item) {
    return ProjectRequestItem(
      requestId: item.id.toString(),
      displayId: item.id.toString(),
      createdBy: item.createdBy.isNotEmpty ? item.createdBy : '-',
      requestDate:
          RequestDateParser.parse(item.tanggalPermintaan) ?? DateTime.now(),
      status: _mapStatus(item.status),
      requestText: item.deskripsi,
      totalItem: item.totalItem ?? 0,
      grandTotal: item.grandTotal ?? 0,
      category: requestCategoryFromString(item.kategoriRequest),
    );
  }

  static RequestStatus _mapStatus(String value) {
    switch (value.trim().toLowerCase()) {
      /// ===== APPROVAL FLOW =====
      case 'disetujui':
      case 'approved':
        return RequestStatus.approved;

      case 'ditolak':
      case 'rejected':
        return RequestStatus.rejected;

      /// ===== REQUEST FLOW (LEGACY) =====
      case 'processed':
      case 'diproses':
        return RequestStatus.processed;

      case 'done':
        return RequestStatus.done;

      /// ===== DEFAULT =====
      case 'pending':
      default:
        return RequestStatus.pending;
    }
  }
}
