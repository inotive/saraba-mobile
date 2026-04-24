import 'package:saraba_mobile/repository/model/history_absensi_item_model.dart';
import 'package:saraba_mobile/repository/model/today_absensi_model.dart';

class AbsensiState {
  final bool isLoading;
  final bool isLoadingToday;
  final bool isLoadingMore;
  final bool isError;
  final String? errorMessage;
  final String? todayErrorMessage;

  final TodayAbsensiData? todayData;
  final List<AbsensiItem> historyList;

  final int currentPage;
  final int lastPage;
  final int perPage;
  final bool hasReachedMax;

  final DateTime selectedMonth;

  const AbsensiState({
    this.isLoading = false,
    this.isLoadingToday = false,
    this.isLoadingMore = false,
    this.isError = false,
    this.errorMessage,
    this.todayErrorMessage,
    this.todayData,
    this.historyList = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.hasReachedMax = false,
    required this.selectedMonth,
  });

  factory AbsensiState.initial() {
    return AbsensiState(selectedMonth: DateTime.now());
  }

  AbsensiState copyWith({
    bool? isLoading,
    bool? isLoadingToday,
    bool? isLoadingMore,
    bool? isError,
    String? errorMessage,
    String? todayErrorMessage,
    TodayAbsensiData? todayData,
    List<AbsensiItem>? historyList,
    int? currentPage,
    int? lastPage,
    int? perPage,
    bool? hasReachedMax,
    DateTime? selectedMonth,
  }) {
    return AbsensiState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingToday: isLoadingToday ?? this.isLoadingToday,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isError: isError ?? this.isError,
      errorMessage: errorMessage,
      todayErrorMessage: todayErrorMessage,
      todayData: todayData ?? this.todayData,
      historyList: historyList ?? this.historyList,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}
