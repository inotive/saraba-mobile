import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AbsensiService absensiService;

  AttendanceBloc(this.absensiService) : super(const AttendanceState()) {
    on<ClockInSubmitted>(_onClockInSubmitted);
    on<ClockOutSubmitted>(_onClockOutSubmitted);
  }

  Future<void> _onClockInSubmitted(
    ClockInSubmitted event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        message: null,
        isSuccess: false,
        isError: false,
      ),
    );

    final result = await absensiService.clockIn(
      latitude: event.latitude,
      longitude: event.longitude,
      imagePath: event.imagePath,
      deviceInfo: event.deviceInfo,
    );

    if (result != null && result.success) {
      emit(
        state.copyWith(
          isLoading: false,
          clockInTime: result.data.absensi.jamMasuk,
          message: result.message,
          isSuccess: true,
          isError: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          message: "Clock in gagal",
          isSuccess: false,
          isError: true,
        ),
      );
    }
  }

  Future<void> _onClockOutSubmitted(
    ClockOutSubmitted event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        message: null,
        isSuccess: false,
        isError: false,
      ),
    );

    final result = await absensiService.clockOut(
      latitude: event.latitude,
      longitude: event.longitude,
      imagePath: event.imagePath,
      deviceInfo: event.deviceInfo,
    );

    if (result != null && result.success) {
      emit(
        state.copyWith(
          isLoading: false,
          clockOutTime: result.data.absensi.jamKeluar,
          message: result.message,
          isSuccess: true,
          isError: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          message: "Clock out gagal",
          isSuccess: false,
          isError: true,
        ),
      );
    }
  }
}
