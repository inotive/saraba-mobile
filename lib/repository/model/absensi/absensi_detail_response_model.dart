class AbsensiDetailResponse {
  final bool success;
  final AbsensiDetailData data;

  AbsensiDetailResponse({
    required this.success,
    required this.data,
  });

  factory AbsensiDetailResponse.fromJson(Map<String, dynamic> json) {
    return AbsensiDetailResponse(
      success: json['success'] == true,
      data: AbsensiDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class AbsensiDetailData {
  final int id;
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;
  final String durasiKerja;
  final String latitude;
  final String longitude;
  final String fotoUrl;
  final String status;
  final String keterangan;
  final String deviceInfo;

  AbsensiDetailData({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.durasiKerja,
    required this.latitude,
    required this.longitude,
    required this.fotoUrl,
    required this.status,
    required this.keterangan,
    required this.deviceInfo,
  });

  factory AbsensiDetailData.fromJson(Map<String, dynamic> json) {
    return AbsensiDetailData(
      id: json['id'] as int? ?? 0,
      tanggal: json['tanggal']?.toString() ?? '',
      jamMasuk: json['jam_masuk']?.toString() ?? '',
      jamPulang: json['jam_pulang']?.toString() ?? '',
      durasiKerja: json['durasi_kerja']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      fotoUrl: json['foto_url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      deviceInfo: json['device_info']?.toString() ?? '',
    );
  }
}
