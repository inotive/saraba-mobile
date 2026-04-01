abstract class PengeluaranDetailEvent {}

class FetchPengeluaranDetail extends PengeluaranDetailEvent {
  final String projectId;
  final String pengeluaranId;

  FetchPengeluaranDetail({
    required this.projectId,
    required this.pengeluaranId,
  });
}
