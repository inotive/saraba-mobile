abstract class TambahPengeluaranEvent {}

class PengeluaranSubmissionPayload {
  final String nama;
  final int jumlah;
  final double nominal;

  const PengeluaranSubmissionPayload({
    required this.nama,
    required this.jumlah,
    required this.nominal,
  });
}

class SubmitPengeluaranRequested extends TambahPengeluaranEvent {
  final String projectId;
  final String kategori;
  final String tanggal;
  final String catatan;
  final List<String> lampiranPaths;
  final List<PengeluaranSubmissionPayload> items;

  SubmitPengeluaranRequested({
    required this.projectId,
    required this.kategori,
    required this.tanggal,
    required this.catatan,
    required this.lampiranPaths,
    required this.items,
  });
}
