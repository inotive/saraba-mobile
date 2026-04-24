import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'package:saraba_mobile/ui/absensi/detail/bloc/absensi_detail_event.dart';
import 'package:saraba_mobile/ui/absensi/detail/bloc/absensi_detail_state.dart';

class AbsensiDetailBloc extends Bloc<AbsensiDetailEvent, AbsensiDetailState> {
  final AbsensiService absensiService;

  AbsensiDetailBloc(this.absensiService) : super(const AbsensiDetailState()) {
    on<FetchAbsensiDetail>(_onFetchAbsensiDetail);
  }

  Future<void> _onFetchAbsensiDetail(
    FetchAbsensiDetail event,
    Emitter<AbsensiDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await absensiService.fetchAbsensiDetail(event.absensiId);

    if (response == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat detail absensi',
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
}
