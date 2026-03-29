abstract class TambahPengeluaranEvent {}

class SubmitPengeluaranRequested extends TambahPengeluaranEvent {
  final String projectId;
  final String namaItem;
  final String kategori;
  final double jumlah;
  final String tanggal;
  final String keterangan;

  SubmitPengeluaranRequested({
    required this.projectId,
    required this.namaItem,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
  });
}
