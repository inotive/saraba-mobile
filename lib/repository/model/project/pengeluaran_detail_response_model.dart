class PengeluaranDetailResponse {
  final bool success;
  final String message;
  final PengeluaranDetailData? data;

  PengeluaranDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PengeluaranDetailResponse.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailResponse(
      success:
          json['success'] == true || json['status']?.toString() == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? PengeluaranDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PengeluaranDetailData {
  final int id;
  final String nomorTransaksi;
  final String kategori;
  final String tanggal;
  final String catatan;
  final PengeluaranDetailUser user;
  final double grandTotal;
  final List<PengeluaranLampiranItem> lampiran;
  final List<PengeluaranDetailItem> items;

  PengeluaranDetailData({
    required this.id,
    required this.nomorTransaksi,
    required this.kategori,
    required this.tanggal,
    required this.catatan,
    required this.user,
    required this.grandTotal,
    required this.lampiran,
    required this.items,
  });

  factory PengeluaranDetailData.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailData(
      id: json['id'] as int? ?? 0,
      nomorTransaksi: json['nomor_transaksi']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      catatan: json['catatan']?.toString() ?? '',
      user: PengeluaranDetailUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? const {},
      ),
      grandTotal: _parseDouble(json['grand_total']),
      lampiran: (json['lampiran'] as List<dynamic>? ?? [])
          .map(
            (item) => PengeluaranLampiranItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                PengeluaranDetailItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PengeluaranDetailUser {
  final int id;
  final String name;

  PengeluaranDetailUser({
    required this.id,
    required this.name,
  });

  factory PengeluaranDetailUser.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailUser(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class PengeluaranLampiranItem {
  final int id;
  final String nama;
  final String url;
  final String extension;

  PengeluaranLampiranItem({
    required this.id,
    required this.nama,
    required this.url,
    required this.extension,
  });

  factory PengeluaranLampiranItem.fromJson(Map<String, dynamic> json) {
    return PengeluaranLampiranItem(
      id: json['id'] as int? ?? 0,
      nama: json['nama']?.toString() ?? '',
      url: _normalizeUrl(json['url']?.toString() ?? ''),
      extension: json['extension']?.toString() ?? '',
    );
  }
}

class PengeluaranDetailItem {
  final int id;
  final String namaItem;
  final int kuantitas;
  final double jumlah;

  PengeluaranDetailItem({
    required this.id,
    required this.namaItem,
    required this.kuantitas,
    required this.jumlah,
  });

  factory PengeluaranDetailItem.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailItem(
      id: json['id'] as int? ?? 0,
      namaItem: json['nama_item']?.toString() ?? '',
      kuantitas: json['kuantitas'] as int? ?? 0,
      jumlah: _parseDouble(json['jumlah']),
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _normalizeUrl(String rawUrl) {
  if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
    return rawUrl;
  }

  if (rawUrl.startsWith('/')) {
    return 'https://saraba.inotivedev.com$rawUrl';
  }

  return rawUrl;
}
