abstract class TambahProgressEvent {}

class SubmitProgressRequested extends TambahProgressEvent {
  final String projectId;
  final String judul;
  final int progressPersen;
  final String tanggal;
  final String catatan;
  final int jumlahTukang;
  final List<String> fotoPaths;

  SubmitProgressRequested({
    required this.projectId,
    required this.judul,
    required this.progressPersen,
    required this.tanggal,
    required this.catatan,
    required this.jumlahTukang,
    this.fotoPaths = const [],
  });
}
