import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'absensi_event.dart';
import 'absensi_state.dart';

class AbsensiBloc extends Bloc<AbsensiEvent, AbsensiState> {
  final AbsensiService absensiService;

  AbsensiBloc(this.absensiService) : super(AbsensiState.initial()) {
    on<LoadAbsensiPage>(_onLoadAbsensiPage);
    on<LoadMoreAbsensiHistory>(_onLoadMoreAbsensiHistory);
    on<ChangeAbsensiMonth>(_onChangeAbsensiMonth);
  }

  Future<void> _onLoadAbsensiPage(
    LoadAbsensiPage event,
    Emitter<AbsensiState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        errorMessage: null,
        currentPage: 1,
        hasReachedMax: false,
      ),
    );

    try {
      final todayResponse = await absensiService.getTodayAbsensi();

      final startDate = _monthStart(state.selectedMonth);
      final endDate = _monthEnd(state.selectedMonth);

      final historyResponse = await absensiService.getHistoryAbsensi(
        startDate: startDate,
        endDate: endDate,
        page: 1,
        perPage: state.perPage,
      );

      if (todayResponse == null || historyResponse == null) {
        emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: 'Gagal memuat data absensi',
          ),
        );
        return;
      }

      final pagination = historyResponse.data.pagination;
      final historyList = historyResponse.data.absensis;

      emit(
        state.copyWith(
          isLoading: false,
          todayData: todayResponse.data,
          historyList: historyList,
          currentPage: pagination.currentPage,
          lastPage: pagination.lastPage,
          hasReachedMax: pagination.currentPage >= pagination.lastPage,
          isError: false,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: 'Terjadi kesalahan saat memuat absensi',
        ),
      );
    }
  }

  Future<void> _onLoadMoreAbsensiHistory(
    LoadMoreAbsensiHistory event,
    Emitter<AbsensiState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax || state.isLoading) return;

    emit(
      state.copyWith(isLoadingMore: true, isError: false, errorMessage: null),
    );

    try {
      final nextPage = state.currentPage + 1;

      final response = await absensiService.getHistoryAbsensi(
        startDate: _monthStart(state.selectedMonth),
        endDate: _monthEnd(state.selectedMonth),
        page: nextPage,
        perPage: state.perPage,
      );

      if (response == null) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            isError: true,
            errorMessage: 'Gagal memuat data berikutnya',
          ),
        );
        return;
      }

      final newItems = response.data.absensis;
      final pagination = response.data.pagination;

      emit(
        state.copyWith(
          isLoadingMore: false,
          historyList: [...state.historyList, ...newItems],
          currentPage: pagination.currentPage,
          lastPage: pagination.lastPage,
          hasReachedMax: pagination.currentPage >= pagination.lastPage,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          isError: true,
          errorMessage: 'Terjadi kesalahan saat memuat data berikutnya',
        ),
      );
    }
  }

  Future<void> _onChangeAbsensiMonth(
    ChangeAbsensiMonth event,
    Emitter<AbsensiState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMonth: event.selectedMonth,
        currentPage: 1,
        hasReachedMax: false,
        historyList: [],
      ),
    );

    add(LoadAbsensiPage());
  }

  String _monthStart(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));
  }

  String _monthEnd(DateTime date) {
    return DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime(date.year, date.month + 1, 0));
  }
}
