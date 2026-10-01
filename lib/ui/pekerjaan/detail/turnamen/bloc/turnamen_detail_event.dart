abstract class TurnamenDetailEvent {}

class FetchTurnamenDetail extends TurnamenDetailEvent {
  final String turnamenId;

  FetchTurnamenDetail(this.turnamenId);
}
