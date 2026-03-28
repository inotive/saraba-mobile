import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final PekerjaanService pekerjaanService;

  ProjectDetailBloc(this.pekerjaanService) : super(const ProjectDetailState()) {
    on<FetchProjectDetail>(_onFetchProjectDetail);
  }

  Future<void> _onFetchProjectDetail(
    FetchProjectDetail event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await pekerjaanService.fetchProyekDetail(event.projectId);

    if (response == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat detail proyek',
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
