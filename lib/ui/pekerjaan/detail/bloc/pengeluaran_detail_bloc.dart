import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/pengeluaran_detail_state.dart';

class PengeluaranDetailBloc
    extends Bloc<PengeluaranDetailEvent, PengeluaranDetailState> {
  final PekerjaanService pekerjaanService;

  PengeluaranDetailBloc(this.pekerjaanService)
    : super(const PengeluaranDetailState()) {
    on<FetchPengeluaranDetail>(_onFetchPengeluaranDetail);
    on<DeletePengeluaran>(_onDeletePengeluaran);
  }

  Future<void> _onFetchPengeluaranDetail(
    FetchPengeluaranDetail event,
    Emitter<PengeluaranDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await pekerjaanService.fetchPengeluaranDetail(
      projectId: event.projectId,
      pengeluaranId: event.pengeluaranId,
    );

    if (response == null || !response.success || response.data == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: response?.message.isNotEmpty == true
              ? response!.message
              : 'Gagal memuat detail pengeluaran',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        detail: response.data,
        clearError: true,
      ),
    );
  }

  Future<void> _onDeletePengeluaran(
    DeletePengeluaran event,
    Emitter<PengeluaranDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isDeleting: true,
        clearDeleteError: true,
        clearDeleteSuccess: true,
      ),
    );

    final response = await pekerjaanService.deletePengeluaran(
      projectId: event.projectId,
      pengeluaranId: event.pengeluaranId,
    );

    if (response == null || !response.success) {
      emit(
        state.copyWith(
          isDeleting: false,
          deleteErrorMessage: response?.message.isNotEmpty == true
              ? response!.message
              : 'Gagal menghapus pengeluaran',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isDeleting: false,
        deleteSuccessMessage: response.message.isNotEmpty
            ? response.message
            : 'Pengeluaran berhasil dihapus',
        clearDeleteError: true,
      ),
    );
  }
}
