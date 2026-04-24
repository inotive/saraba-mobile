abstract class ProjectDetailEvent {}

class FetchProjectDetail extends ProjectDetailEvent {
  final String projectId;

  FetchProjectDetail(this.projectId);
}
