class AbsensiDetailResponse {
  final bool success;
  final AbsensiDetailData data;

  AbsensiDetailResponse({required this.success, required this.data});

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
  final String latMasuk;
  final String longMasuk;
  final String latPulang;
  final String longPulang;
  final String fotoMasuk;
  final String fotoPulang;
  final String fotoMasukUrl;
  final String fotoPulangUrl;
  final String status;
  final String keterangan;

  AbsensiDetailData({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
    required this.durasiKerja,
    required this.latMasuk,
    required this.longMasuk,
    required this.latPulang,
    required this.longPulang,
    required this.fotoMasuk,
    required this.fotoPulang,
    required this.fotoMasukUrl,
    required this.fotoPulangUrl,
    required this.status,
    required this.keterangan,
  });

  factory AbsensiDetailData.fromJson(Map<String, dynamic> json) {
    return AbsensiDetailData(
      id: json['id'] as int? ?? 0,
      tanggal: json['tanggal']?.toString() ?? '',
      jamMasuk: json['jam_masuk']?.toString() ?? '',
      jamPulang: json['jam_pulang']?.toString() ?? '',
      durasiKerja: json['durasi_kerja']?.toString() ?? '',
      latMasuk: json['lat_masuk']?.toString() ?? '',
      longMasuk: json['long_masuk']?.toString() ?? '',
      latPulang: json['lat_pulang']?.toString() ?? '',
      longPulang: json['long_pulang']?.toString() ?? '',
      fotoMasuk: json['foto_masuk']?.toString() ?? '',
      fotoPulang: json['foto_pulang']?.toString() ?? '',
      fotoMasukUrl: json['foto_masuk_url']?.toString() ?? '',
      fotoPulangUrl: json['foto_pulang_url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
    );
  }
}
