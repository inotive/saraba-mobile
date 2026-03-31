abstract class ProjectProfitEvent {}

class FetchProjectProfits extends ProjectProfitEvent {
  final int page;

  FetchProjectProfits({this.page = 1});
}

class FetchGuaranteeProfits extends ProjectProfitEvent {
  final int page;

  FetchGuaranteeProfits({this.page = 1});
}
