import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/tambah_pengeluaran_state.dart';

class TambahPengeluaranBloc
    extends Bloc<TambahPengeluaranEvent, TambahPengeluaranState> {
  final PekerjaanService pekerjaanService;

  TambahPengeluaranBloc(this.pekerjaanService)
    : super(const TambahPengeluaranState()) {
    on<SubmitPengeluaranRequested>(_onSubmitPengeluaranRequested);
  }

  Future<void> _onSubmitPengeluaranRequested(
    SubmitPengeluaranRequested event,
    Emitter<TambahPengeluaranState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final response = await pekerjaanService.submitPengeluaran(
      projectId: event.projectId,
      namaItem: event.namaItem,
      kategori: event.kategori,
      jumlah: event.jumlah,
      tanggal: event.tanggal,
      keterangan: event.keterangan,
    );

    if (response == null || !response.success) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: response?.message.isNotEmpty == true
              ? response!.message
              : 'Gagal menambahkan pengeluaran',
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
            : 'Pengeluaran berhasil ditambahkan',
        clearError: true,
      ),
    );
  }
}
