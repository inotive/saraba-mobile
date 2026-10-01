import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/bloc/turnamen_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/bloc/turnamen_detail_state.dart';

class TurnamenDetailBloc
    extends Bloc<TurnamenDetailEvent, TurnamenDetailState> {
  final PekerjaanService pekerjaanService;

  TurnamenDetailBloc(this.pekerjaanService)
    : super(const TurnamenDetailState()) {
    on<FetchTurnamenDetail>(_onFetchTurnamenDetail);
  }

  Future<void> _onFetchTurnamenDetail(
    FetchTurnamenDetail event,
    Emitter<TurnamenDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await pekerjaanService.fetchTurnamenDetail(
      event.turnamenId,
    );

    if (response == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat detail turnamen',
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
