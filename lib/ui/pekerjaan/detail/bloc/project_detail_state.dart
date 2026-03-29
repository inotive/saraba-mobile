import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';

class ProjectDetailState {
  final bool isLoading;
  final ProjectDetailData? detail;
  final String? errorMessage;

  const ProjectDetailState({
    this.isLoading = false,
    this.detail,
    this.errorMessage,
  });

  ProjectDetailState copyWith({
    bool? isLoading,
    ProjectDetailData? detail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
