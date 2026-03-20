class AbsensiItem {
  final String id;
  final String tanggal;
  final String jamMasuk;
  final String jamKeluar;
  final String durasiKerja;
  final String status;
  final String keterangan;

  AbsensiItem({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.durasiKerja,
    required this.status,
    required this.keterangan,
  });

  factory AbsensiItem.fromJson(Map<String, dynamic> json) {
    return AbsensiItem(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal'] ?? '',
      jamMasuk: json['jam_masuk'] ?? '',
      jamKeluar: json['jam_keluar'] ?? '',
      durasiKerja: json['durasi_kerja'] ?? '',
      status: json['status'] ?? '',
      keterangan: json['keterangan'] ?? '', // for UI
    );
  }
}
