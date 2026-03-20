abstract class AttendanceEvent {}

class ClockInSubmitted extends AttendanceEvent {
  final String latitude;
  final String longitude;
  final String imagePath;
  final String deviceInfo;

  ClockInSubmitted({
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.deviceInfo,
  });
}

class ClockOutSubmitted extends AttendanceEvent {
  final String latitude;
  final String longitude;
  final String imagePath;
  final String deviceInfo;

  ClockOutSubmitted({
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.deviceInfo,
  });
}
