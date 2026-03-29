class TambahPengeluaranState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;

  const TambahPengeluaranState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
  });

  TambahPengeluaranState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return TambahPengeluaranState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
