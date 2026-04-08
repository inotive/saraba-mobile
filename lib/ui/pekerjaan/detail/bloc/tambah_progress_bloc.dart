import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_progress_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_progress_state.dart';

class TambahProgressBloc
    extends Bloc<TambahProgressEvent, TambahProgressState> {
  final PekerjaanService pekerjaanService;

  TambahProgressBloc(this.pekerjaanService)
    : super(const TambahProgressState()) {
    on<SubmitProgressRequested>(_onSubmitProgressRequested);
  }

  Future<void> _onSubmitProgressRequested(
    SubmitProgressRequested event,
    Emitter<TambahProgressState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final response = await pekerjaanService.submitProgressLog(
      projectId: event.projectId,
      judul: event.judul,
      progressPersen: event.progressPersen,
      tanggal: event.tanggal,
      catatan: event.catatan,
      jumlahTukang: event.jumlahTukang,
      fotoPaths: event.fotoPaths,
    );

    if (response == null || !response.success) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: response?.message.isNotEmpty == true
              ? response!.message
              : 'Gagal menambahkan progress',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successMessage: response.message.isNotEmpty
            ? response.message
            : 'Progress berhasil ditambahkan',
        clearError: true,
      ),
    );
  }
}
