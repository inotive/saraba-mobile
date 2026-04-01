import 'package:saraba_mobile/repository/model/project/pengeluaran_detail_response_model.dart';

class PengeluaranDetailState {
  final bool isLoading;
  final bool isDeleting;
  final PengeluaranDetailData? detail;
  final String? errorMessage;
  final String? deleteSuccessMessage;
  final String? deleteErrorMessage;

  const PengeluaranDetailState({
    this.isLoading = false,
    this.isDeleting = false,
    this.detail,
    this.errorMessage,
    this.deleteSuccessMessage,
    this.deleteErrorMessage,
  });

  PengeluaranDetailState copyWith({
    bool? isLoading,
    bool? isDeleting,
    PengeluaranDetailData? detail,
    String? errorMessage,
    String? deleteSuccessMessage,
    String? deleteErrorMessage,
    bool clearError = false,
    bool clearDeleteSuccess = false,
    bool clearDeleteError = false,
  }) {
    return PengeluaranDetailState(
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      deleteSuccessMessage: clearDeleteSuccess
          ? null
          : deleteSuccessMessage ?? this.deleteSuccessMessage,
      deleteErrorMessage: clearDeleteError
          ? null
          : deleteErrorMessage ?? this.deleteErrorMessage,
    );
  }
}
