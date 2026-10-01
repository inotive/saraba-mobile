import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_state.dart';

class PekerjaanBloc extends Bloc<PekerjaanEvent, PekerjaanState> {
  final PekerjaanService pekerjaanService;

  PekerjaanBloc(this.pekerjaanService) : super(const PekerjaanState()) {
    on<FetchProyeks>(_onFetchProyeks);
    on<ChangePekerjaanFilter>(_onChangeFilter);
  }

  Future<void> _onFetchProyeks(
    FetchProyeks event,
    Emitter<PekerjaanState> emit,
  ) {
    return _load(event.page, state.filter, emit);
  }

  Future<void> _onChangeFilter(
    ChangePekerjaanFilter event,
    Emitter<PekerjaanState> emit,
  ) {
    if (event.filter == state.filter) {
      return Future.value();
    }

    // Daftar lama dikosongkan agar item dari filter sebelumnya tidak tampil
    emit(
      state.copyWith(
        filter: event.filter,
        projects: const [],
        currentPage: 1,
        lastPage: 1,
        isLoadingMore: false,
        clearError: true,
      ),
    );
    return _load(1, event.filter, emit);
  }

  Future<void> _load(
    int page,
    PekerjaanFilter filter,
    Emitter<PekerjaanState> emit,
  ) async {
    final isLoadMore = page > 1;

    if (isLoadMore) {
      if (state.isLoadingMore || state.currentPage >= state.lastPage) {
        return;
      }
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    } else {
      emit(state.copyWith(isLoading: true, clearError: true));
    }

    final response = await pekerjaanService.fetchPekerjaan(
      page: page,
      filter: filter,
    );

    // Filter berubah selagi permintaan berjalan: hasil lama diabaikan
    if (state.filter != filter) {
      return;
    }

    if (response == null) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: 'Gagal memuat data',
        ),
      );
      return;
    }

    final newProjects = pekerjaanService.mapPekerjaanToProjectModels(
      response.data.items,
    );
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
