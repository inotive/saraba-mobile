class AttendanceState {
  final bool isLoading;
  final String? clockInTime;
  final String? clockOutTime;
  final String? message;
  final bool isSuccess;
  final bool isError;

  const AttendanceState({
    this.isLoading = false,
    this.clockInTime,
    this.clockOutTime,
    this.message,
    this.isSuccess = false,
    this.isError = false,
  });

  AttendanceState copyWith({
    bool? isLoading,
    String? clockInTime,
    String? clockOutTime,
    String? message,
    bool? isSuccess,
    bool? isError,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      message: message,
      isSuccess: isSuccess ?? false,
      isError: isError ?? false,
    );
  }
}
