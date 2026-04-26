import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_status.dart';

class ProjectRequestItem {
  final String requestId;
  final String displayId;
  final String createdBy;
  final DateTime requestDate;
  final RequestStatus status;
  final String requestText;
  final int totalItem;
  final double grandTotal;

  const ProjectRequestItem({
    required this.requestId,
    required this.displayId,
    required this.createdBy,
    required this.requestDate,
    required this.status,
    required this.requestText,
    required this.totalItem,
    required this.grandTotal,
  });

  ProjectRequestItem copyWith({
    String? requestId,
    String? displayId,
    String? createdBy,
    DateTime? requestDate,
    RequestStatus? status,
    String? requestText,
    int? totalItem,
    double? grandTotal,
  }) {
    return ProjectRequestItem(
      requestId: requestId ?? this.requestId,
      displayId: displayId ?? this.displayId,
      createdBy: createdBy ?? this.createdBy,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      requestText: requestText ?? this.requestText,
      totalItem: totalItem ?? this.totalItem,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }
}
