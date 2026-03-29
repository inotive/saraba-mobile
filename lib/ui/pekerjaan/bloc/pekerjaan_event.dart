abstract class PekerjaanEvent {}

class FetchProyeks extends PekerjaanEvent {
  final int page;

  FetchProyeks({this.page = 1});
}
