import 'package:hive/hive.dart';

part 'history_absensi_item_model.g.dart';

@HiveType(typeId: 1)
class AbsensiItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String tanggal;
  @HiveField(2)
  final String jamMasuk;
  @HiveField(3)
  final String jamKeluar;
  @HiveField(4)
  final String durasiKerja;
  @HiveField(5)
  final String status;
  @HiveField(6)
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
