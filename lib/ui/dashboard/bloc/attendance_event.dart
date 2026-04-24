abstract class AttendanceEvent {}

class ClockInSubmitted extends AttendanceEvent {
  final String latitude;
  final String longitude;
  final String imagePath;
  final String keterangan;

  ClockInSubmitted({
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.keterangan,
  });
}

class ClockOutSubmitted extends AttendanceEvent {
  final String latitude;
  final String longitude;
  final String imagePath;
  final String keterangan;

  ClockOutSubmitted({
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.keterangan,
  });
}
