import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/history_absensi_item_model.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'absensi_event.dart';
import 'absensi_state.dart';

class AbsensiBloc extends Bloc<AbsensiEvent, AbsensiState> {
  final AbsensiService absensiService;

  AbsensiBloc(this.absensiService) : super(AbsensiState.initial()) {
    on<FetchTodayAbsensi>(_onFetchTodayAbsensi);
    on<LoadAbsensiPage>(_onLoadAbsensiPage);
    on<LoadMoreAbsensiHistory>(_onLoadMoreAbsensiHistory);
    on<ChangeAbsensiMonth>(_onChangeAbsensiMonth);
  }

  Future<void> _onFetchTodayAbsensi(
    FetchTodayAbsensi event,
    Emitter<AbsensiState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingToday: true,
        todayErrorMessage: null,
      ),
    );

    try {
      final todayResponse = await absensiService.fetchTodayAbsensi();

      if (todayResponse == null) {
        emit(
          state.copyWith(
            isLoadingToday: false,
            todayErrorMessage: 'Gagal memuat data absensi hari ini',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLoadingToday: false,
          todayData: todayResponse.data,
          todayErrorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingToday: false,
          todayErrorMessage: 'Gagal memuat data absensi hari ini',
        ),
      );
    }
  }

  Future<void> _onLoadAbsensiPage(
    LoadAbsensiPage event,
    Emitter<AbsensiState> emit,
  ) async {
    final box = Hive.box<AbsensiItem>("absensi_history");
    final cachedItems = box.values.toList();

    if (cachedItems.isNotEmpty) {
      emit(
        state.copyWith(
          historyList: cachedItems,
          isLoading: false,
          isError: false,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: true,
          isError: false,
          errorMessage: null,
          currentPage: 1,
          hasReachedMax: false,
        ),
      );
    }

    try {
      final startDate = _monthStart(state.selectedMonth);
      final endDate = _monthEnd(state.selectedMonth);

      final historyResponse = await absensiService.getHistoryAbsensi(
        startDate: startDate,
        endDate: endDate,
        page: 1,
        perPage: state.perPage,
      );

      if (historyResponse == null) {
        if (cachedItems.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              isError: true,
              errorMessage: 'Gagal memuat data absensi',
            ),
          );
        }
        return;
      }

      final pagination = historyResponse.data.pagination;
      final historyList = historyResponse.data.absensis;

      await box.clear();
      await box.addAll(historyList);

      emit(
        state.copyWith(
          isLoading: false,
          historyList: historyList,
          currentPage: pagination.currentPage,
          lastPage: pagination.lastPage,
          hasReachedMax: pagination.currentPage >= pagination.lastPage,
          isError: false,
          errorMessage: null,
        ),
      );
    } catch (_) {
      if (cachedItems.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: 'Tidak ada koneksi & cache kosong',
          ),
        );
      }
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
