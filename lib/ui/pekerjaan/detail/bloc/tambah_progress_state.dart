class TambahProgressState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;

  const TambahProgressState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
  });

  TambahProgressState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return TambahProgressState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
