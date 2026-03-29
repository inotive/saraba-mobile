class SubmitAbsensiResponse {
  final String status;
  final String message;
  final SubmitAbsensiData data;

  SubmitAbsensiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory SubmitAbsensiResponse.fromJson(Map<String, dynamic> json) {
    return SubmitAbsensiResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: SubmitAbsensiData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SubmitAbsensiData {
  final int id;
  final String userId;
  final int? proyekId;
  final String tanggal;
  final String jamMasuk;
  final String jamPulang;
  final String latMasuk;
  final String longMasuk;
  final String latPulang;
  final String longPulang;
  final String fotoMasuk;
  final String fotoPulang;
  final String status;
  final String keterangan;
  final String createdAt;
  final String updatedAt;
  final String latitude;
  final String longitude;
  final String fotoPath;
  final String ipAddress;
  final String deviceInfo;

  SubmitAbsensiData({
    required this.id,
    required this.userId,
    required this.proyekId,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.latMasuk,
    required this.longMasuk,
    required this.latPulang,
    required this.longPulang,
    required this.fotoMasuk,
    required this.fotoPulang,
    required this.status,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
    required this.fotoPath,
    required this.ipAddress,
    required this.deviceInfo,
  });

  factory SubmitAbsensiData.fromJson(Map<String, dynamic> json) {
    return SubmitAbsensiData(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      proyekId: json['proyek_id'] as int?,
      tanggal: json['tanggal']?.toString() ?? '',
      jamMasuk: json['jam_masuk']?.toString() ?? '',
      jamPulang: json['jam_pulang']?.toString() ?? '',
      latMasuk: json['lat_masuk']?.toString() ?? '',
      longMasuk: json['long_masuk']?.toString() ?? '',
      latPulang: json['lat_pulang']?.toString() ?? '',
      longPulang: json['long_pulang']?.toString() ?? '',
      fotoMasuk: json['foto_masuk']?.toString() ?? '',
      fotoPulang: json['foto_pulang']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      fotoPath: json['foto_path']?.toString() ?? '',
      ipAddress: json['ip_address']?.toString() ?? '',
      deviceInfo: json['device_info']?.toString() ?? '',
    );
  }
}
