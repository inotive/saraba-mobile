import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';

class TurnamenDetailState {
  final bool isLoading;
  final TurnamenDetailData? detail;
  final String? errorMessage;

  const TurnamenDetailState({
    this.isLoading = false,
    this.detail,
    this.errorMessage,
  });

  TurnamenDetailState copyWith({
    bool? isLoading,
    TurnamenDetailData? detail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TurnamenDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
