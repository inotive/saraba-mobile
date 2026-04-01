import 'package:saraba_mobile/repository/model/project/pengeluaran_detail_response_model.dart';

class PengeluaranDetailState {
  final bool isLoading;
  final PengeluaranDetailData? detail;
  final String? errorMessage;

  const PengeluaranDetailState({
    this.isLoading = false,
    this.detail,
    this.errorMessage,
  });

  PengeluaranDetailState copyWith({
    bool? isLoading,
    PengeluaranDetailData? detail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PengeluaranDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
