import 'package:saraba_mobile/repository/model/pagination_model.dart';

class GuaranteeProfitResponse {
  final bool success;
  final String message;
  final GuaranteeProfitData data;

  GuaranteeProfitResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GuaranteeProfitResponse.fromJson(Map<String, dynamic> json) {
    return GuaranteeProfitResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      data: GuaranteeProfitData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class GuaranteeProfitData {
  final List<GuaranteeProfitItem> jaminans;
  final Pagination pagination;

  GuaranteeProfitData({
    required this.jaminans,
    required this.pagination,
  });

  factory GuaranteeProfitData.fromJson(Map<String, dynamic> json) {
    return GuaranteeProfitData(
      jaminans: (json['jaminans'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(GuaranteeProfitItem.fromJson)
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class GuaranteeProfitItem {
  final int id;
  final String proyekId;
  final String proyekNama;
  final String noJaminan;
  final String noBlanko;
  final String jenisJaminan;
  final String penerbit;
  final double nilaiJaminan;
  final String tglTerbit;
  final String jangkaWaktu;
  final String penerima;
  final String namaNasabah;
  final String nasabahOrang;
  final String jaminanAset;
  final String kota;
  final String payment;
  final String status;
  final String statusText;
  final String keterangan;
  final String catatan;
  final String createdAt;

  GuaranteeProfitItem({
    required this.id,
    required this.proyekId,
    required this.proyekNama,
    required this.noJaminan,
    required this.noBlanko,
    required this.jenisJaminan,
    required this.penerbit,
    required this.nilaiJaminan,
    required this.tglTerbit,
    required this.jangkaWaktu,
    required this.penerima,
    required this.namaNasabah,
    required this.nasabahOrang,
    required this.jaminanAset,
    required this.kota,
    required this.payment,
    required this.status,
    required this.statusText,
    required this.keterangan,
    required this.catatan,
    required this.createdAt,
  });

  factory GuaranteeProfitItem.fromJson(Map<String, dynamic> json) {
    return GuaranteeProfitItem(
      id: _parseInt(json['id']),
      proyekId: json['proyek_id']?.toString() ?? '',
      proyekNama: json['proyek_nama'] as String? ?? '',
      noJaminan: json['no_jaminan'] as String? ?? '',
      noBlanko: json['no_blanko'] as String? ?? '',
      jenisJaminan: json['jenis_jaminan'] as String? ?? '',
      penerbit: json['penerbit'] as String? ?? '',
      nilaiJaminan: _parseDouble(json['nilai_jaminan']),
      tglTerbit: json['tgl_terbit'] as String? ?? '',
      jangkaWaktu: json['jangka_waktu']?.toString() ?? '',
      penerima: json['penerima'] as String? ?? '',
      namaNasabah: json['nama_nasabah'] as String? ?? '',
      nasabahOrang: json['nasabah_orang'] as String? ?? '',
      jaminanAset: json['jaminan_aset'] as String? ?? '',
      kota: json['kota'] as String? ?? '',
      payment: json['payment'] as String? ?? '',
      status: json['status']?.toString() ?? '',
      statusText: json['status_text'] as String? ?? '',
      keterangan: json['keterangan'] as String? ?? '',
      catatan: json['catatan'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _parseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
