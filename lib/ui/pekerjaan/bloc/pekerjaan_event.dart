import 'package:saraba_mobile/repository/model/project_model.dart';

abstract class PekerjaanEvent {}

/// Memuat satu halaman daftar (proyek + turnamen) sesuai filter yang sedang aktif.
class FetchProyeks extends PekerjaanEvent {
  final int page;

  FetchProyeks({this.page = 1});
}

/// Mengganti filter jenis (Semua / Proyek / Turnamen) lalu memuat ulang dari halaman 1.
class ChangePekerjaanFilter extends PekerjaanEvent {
  final PekerjaanFilter filter;

  ChangePekerjaanFilter(this.filter);
}
