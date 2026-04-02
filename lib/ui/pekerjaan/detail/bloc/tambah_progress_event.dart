abstract class TambahProgressEvent {}

class SubmitProgressRequested extends TambahProgressEvent {
  final String projectId;
  final String judul;
  final int progressPersen;
  final String tanggal;
  final String catatan;
  final List<String> fotoPaths;

  SubmitProgressRequested({
    required this.projectId,
    required this.judul,
    required this.progressPersen,
    required this.tanggal,
    required this.catatan,
    this.fotoPaths = const [],
  });
}
