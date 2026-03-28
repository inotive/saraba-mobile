abstract class AbsensiDetailEvent {}

class FetchAbsensiDetail extends AbsensiDetailEvent {
  final String absensiId;

  FetchAbsensiDetail(this.absensiId);
}
