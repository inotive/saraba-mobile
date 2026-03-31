import 'package:saraba_mobile/repository/model/project_profit/project_profit_response_model.dart';

class ProjectProfitState {
  final bool isLoading;
  final String? errorMessage;
  final ProjectProfitSummary? summary;
  final List<ProjectProfitItem> items;

  const ProjectProfitState({
    this.isLoading = false,
    this.errorMessage,
    this.summary,
    this.items = const [],
  });

  ProjectProfitState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    ProjectProfitSummary? summary,
    List<ProjectProfitItem>? items,
  }) {
    return ProjectProfitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      summary: summary ?? this.summary,
      items: items ?? this.items,
    );
  }
}
