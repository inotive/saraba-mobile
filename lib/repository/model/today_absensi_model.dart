class TodayAbsensiResponse {
  final bool success;
  final TodayAbsensiData data;

  TodayAbsensiResponse({required this.success, required this.data});

  factory TodayAbsensiResponse.fromJson(Map<String, dynamic> json) {
    return TodayAbsensiResponse(
      success: json['success'] ?? false,
      data: TodayAbsensiData.fromJson(json['data'] ?? {}),
    );
  }
}

class TodayAbsensiData {
  final String today;
  final bool isClockedIn;
  final bool isClockedOut;
  final AbsensiToday? absensi;

  TodayAbsensiData({
    required this.today,
    required this.isClockedIn,
    required this.isClockedOut,
    this.absensi,
  });

  factory TodayAbsensiData.fromJson(Map<String, dynamic> json) {
    return TodayAbsensiData(
      today: json['today'] ?? '',
      isClockedIn:
          json['is_clocked_in'] == "true" || json['is_clocked_in'] == true,
      isClockedOut:
          json['is_clocked_out'] == "true" || json['is_clocked_out'] == true,
      absensi: json['absensi'] != null
          ? AbsensiToday.fromJson(json['absensi'])
          : null,
    );
  }
}

class AbsensiToday {
  final String id;
  final String jamMasuk;
  final String jamKeluar;
  final String durasiKerja;
  final String status;

  AbsensiToday({
    required this.id,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.durasiKerja,
    required this.status,
  });

  factory AbsensiToday.fromJson(Map<String, dynamic> json) {
    return AbsensiToday(
      id: json['id']?.toString() ?? '',
      jamMasuk: json['jam_masuk'] ?? '',
      jamKeluar: json['jam_keluar'] ?? '',
      durasiKerja: json['durasi_kerja'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
