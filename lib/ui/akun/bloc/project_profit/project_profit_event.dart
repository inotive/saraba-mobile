abstract class ProjectProfitEvent {}

class FetchProjectProfits extends ProjectProfitEvent {
  final int page;

  FetchProjectProfits({this.page = 1});
}
