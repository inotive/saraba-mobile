import 'package:saraba_mobile/repository/model/project_profit/guarantee_profit_response_model.dart';
import 'package:saraba_mobile/repository/model/project_profit/project_profit_response_model.dart';

class ProjectProfitState {
  final bool isLoading;
  final String? errorMessage;
  final ProjectProfitSummary? summary;
  final List<ProjectProfitItem> items;
  final bool isGuaranteeLoading;
  final String? guaranteeErrorMessage;
  final List<GuaranteeProfitItem> guaranteeItems;

  const ProjectProfitState({
    this.isLoading = false,
    this.errorMessage,
    this.summary,
    this.items = const [],
    this.isGuaranteeLoading = false,
    this.guaranteeErrorMessage,
    this.guaranteeItems = const [],
  });

  ProjectProfitState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    ProjectProfitSummary? summary,
    List<ProjectProfitItem>? items,
    bool? isGuaranteeLoading,
    String? guaranteeErrorMessage,
    bool clearGuaranteeErrorMessage = false,
    List<GuaranteeProfitItem>? guaranteeItems,
  }) {
    return ProjectProfitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      summary: summary ?? this.summary,
      items: items ?? this.items,
      isGuaranteeLoading: isGuaranteeLoading ?? this.isGuaranteeLoading,
      guaranteeErrorMessage: clearGuaranteeErrorMessage
          ? null
          : guaranteeErrorMessage ?? this.guaranteeErrorMessage,
      guaranteeItems: guaranteeItems ?? this.guaranteeItems,
    );
  }
}
