import 'package:saraba_mobile/repository/model/request_approval/request_approval_detail_model.dart';
import 'package:saraba_mobile/repository/model/request_approval/request_approval_model.dart';

class ApprovalState {
  final bool isLoading;
  final List<RequestApprovalData> requests;
  final RequestApprovalDetail? detail;
  final String? error;

  const ApprovalState({
    this.isLoading = false,
    this.requests = const [],
    this.detail,
    this.error,
  });

  ApprovalState copyWith({
    bool? isLoading,
    List<RequestApprovalData>? requests,
    RequestApprovalDetail? detail,
    String? error,
  }) {
    return ApprovalState(
      isLoading: isLoading ?? this.isLoading,
      requests: requests ?? this.requests,
      detail: detail ?? this.detail,
      error: error,
    );
  }
}
