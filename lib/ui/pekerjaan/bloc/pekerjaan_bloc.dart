import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_state.dart';

class PekerjaanBloc extends Bloc<PekerjaanEvent, PekerjaanState> {
  final PekerjaanService pekerjaanService;

  PekerjaanBloc(this.pekerjaanService) : super(const PekerjaanState()) {
    on<FetchProyeks>(_onFetchProyeks);
  }

  Future<void> _onFetchProyeks(
    FetchProyeks event,
    Emitter<PekerjaanState> emit,
  ) async {
    final isLoadMore = event.page > 1;

    if (isLoadMore) {
      if (state.isLoadingMore || state.currentPage >= state.lastPage) {
        return;
      }
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    } else {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    final response = await pekerjaanService.fetchProyeks(page: event.page);

    if (response == null) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: 'Gagal memuat data proyek',
        ),
      );
      return;
    }

    final newProjects = pekerjaanService.mapToProjectModels(response.data.proyeks);
    final mergedProjects = isLoadMore
        ? [...state.projects, ...newProjects]
        : newProjects;

    emit(
      state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        projects: mergedProjects,
        currentPage: response.data.pagination.currentPage,
        lastPage: response.data.pagination.lastPage,
        clearError: true,
      ),
    );
  }
}
