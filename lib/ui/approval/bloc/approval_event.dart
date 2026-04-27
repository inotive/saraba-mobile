abstract class ApprovalEvent {}

class FetchRequests extends ApprovalEvent {
  final String? status;

  FetchRequests({this.status});
}

class FetchRequestDetail extends ApprovalEvent {
  final String requestId;

  FetchRequestDetail(this.requestId);
}

class ApproveRequest extends ApprovalEvent {
  final String requestId;

  ApproveRequest(this.requestId);
}

class RejectRequest extends ApprovalEvent {
  final String requestId;

  RejectRequest(this.requestId);
}
