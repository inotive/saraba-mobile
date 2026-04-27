class ProjectRequestFormResult {
  final DateTime requestDate;
  final String requestText;
  final List<Map<String, dynamic>> items;

  const ProjectRequestFormResult({
    required this.requestDate,
    required this.requestText,
    required this.items,
  });
}
