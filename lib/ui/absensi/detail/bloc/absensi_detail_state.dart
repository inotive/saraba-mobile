import 'package:saraba_mobile/repository/model/absensi/absensi_detail_response_model.dart';

class AbsensiDetailState {
  final bool isLoading;
  final AbsensiDetailData? detail;
  final String? errorMessage;

  const AbsensiDetailState({
    this.isLoading = false,
    this.detail,
    this.errorMessage,
  });

  AbsensiDetailState copyWith({
    bool? isLoading,
    AbsensiDetailData? detail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AbsensiDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
