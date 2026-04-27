import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/request_approval_service.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_event.dart';
import 'package:saraba_mobile/ui/approval/bloc/approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final RequestApprovalService service;

  ApprovalBloc(this.service) : super(const ApprovalState()) {
    on<FetchRequests>(_onFetchRequests);
    on<FetchRequestDetail>(_onFetchDetail);
    on<ApproveRequest>(_onApprove);
    on<RejectRequest>(_onReject);
  }

  Future<void> _onFetchRequests(
    FetchRequests event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await service.fetchRequestApproval(status: event.status);

    if (response != null) {
      emit(state.copyWith(isLoading: false, requests: response.data));
    }
  }

  Future<void> _onFetchDetail(
    FetchRequestDetail event,
    Emitter<ApprovalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await service.fetchDetailRequestApproval(event.requestId);

    if (response != null) {
      emit(state.copyWith(isLoading: false, detail: response.data));
    }
  }

  Future<void> _onApprove(
    ApproveRequest event,
    Emitter<ApprovalState> emit,
  ) async {
    await service.approveRequestApproval(
      permintaanId: event.requestId,
      tanggalPermintaan: '',
      deskripsi: '',
    );
  }

  Future<void> _onReject(
    RejectRequest event,
    Emitter<ApprovalState> emit,
  ) async {
    await service.rejectRequestApproval(
      projectId: '',
      requestId: event.requestId,
      tanggalPermintaan: '',
      deskripsi: '',
    );
  }
}
