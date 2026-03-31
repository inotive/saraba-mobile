import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/project_profit_service.dart';
import 'package:saraba_mobile/ui/akun/bloc/project_profit/project_profit_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/project_profit/project_profit_state.dart';

class ProjectProfitBloc extends Bloc<ProjectProfitEvent, ProjectProfitState> {
  final ProjectProfitService projectProfitService;

  ProjectProfitBloc(this.projectProfitService)
      : super(const ProjectProfitState()) {
    on<FetchProjectProfits>(_onFetchProjectProfits);
  }

  Future<void> _onFetchProjectProfits(
    FetchProjectProfits event,
    Emitter<ProjectProfitState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    final response = await projectProfitService.fetchProjectProfits(
      page: event.page,
    );

    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: response == null ? 'Gagal memuat keuntungan proyek' : null,
        summary: response?.summary,
        items: response?.data ?? const [],
      ),
    );
  }
}
