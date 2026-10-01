import 'package:saraba_mobile/repository/model/project_model.dart';

class PekerjaanState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ProjectModel> projects;
  final PekerjaanFilter filter;
  final int currentPage;
  final int lastPage;
  final String? errorMessage;

  const PekerjaanState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.projects = const [],
    this.filter = PekerjaanFilter.all,
    this.currentPage = 1,
    this.lastPage = 1,
    this.errorMessage,
  });

  PekerjaanState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ProjectModel>? projects,
    PekerjaanFilter? filter,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PekerjaanState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      projects: projects ?? this.projects,
      filter: filter ?? this.filter,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
