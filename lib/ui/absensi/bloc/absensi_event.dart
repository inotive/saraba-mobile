abstract class AbsensiEvent {}

class FetchTodayAbsensi extends AbsensiEvent {}

class LoadAbsensiPage extends AbsensiEvent {}

class LoadMoreAbsensiHistory extends AbsensiEvent {}

class ChangeAbsensiMonth extends AbsensiEvent {
  final DateTime selectedMonth;

  ChangeAbsensiMonth(this.selectedMonth);
}
