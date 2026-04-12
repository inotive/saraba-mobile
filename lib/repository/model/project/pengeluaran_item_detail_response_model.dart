class PengeluaranItemDetailResponse {
  final bool success;
  final String message;
  final PengeluaranItemDetailData? data;

  const PengeluaranItemDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PengeluaranItemDetailResponse.fromJson(Map<String, dynamic> json) {
    return PengeluaranItemDetailResponse(
      success:
          json['success'] == true || json['status']?.toString() == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? PengeluaranItemDetailData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class PengeluaranItemDetailData {
  final int id;
  final String namaItem;
  final int kuantitas;
  final double jumlah;
  final String kategori;
  final String tanggal;
  final String keterangan;
  final PengeluaranItemDetailUser user;
  final PengeluaranItemDetailBatch batch;
  final List<PengeluaranItemDetailLampiran> lampiran;

  const PengeluaranItemDetailData({
    required this.id,
    required this.namaItem,
    required this.kuantitas,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
    required this.keterangan,
    required this.user,
    required this.batch,
    required this.lampiran,
  });

  factory PengeluaranItemDetailData.fromJson(Map<String, dynamic> json) {
    return PengeluaranItemDetailData(
      id: _parseInt(json['id']),
      namaItem: (json['nama_item'] ?? '').toString(),
      kuantitas: _parseInt(json['kuantitas']),
      jumlah: _parseDouble(json['jumlah']),
      kategori: (json['kategori'] ?? '').toString(),
      tanggal: (json['tanggal'] ?? '').toString(),
      keterangan: (json['keterangan'] ?? '').toString(),
      user: PengeluaranItemDetailUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? const {},
      ),
      batch: PengeluaranItemDetailBatch.fromJson(
        json['batch'] as Map<String, dynamic>? ?? const {},
      ),
      lampiran: (json['lampiran'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(PengeluaranItemDetailLampiran.fromJson)
          .toList(),
    );
  }
}

class PengeluaranItemDetailUser {
  final int id;
  final String name;

  const PengeluaranItemDetailUser({
    required this.id,
    required this.name,
  });

  factory PengeluaranItemDetailUser.fromJson(Map<String, dynamic> json) {
    return PengeluaranItemDetailUser(
      id: _parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
    );
  }
}

class PengeluaranItemDetailBatch {
  final String nomorTransaksi;
  final double totalBatch;
  final int totalItems;

  const PengeluaranItemDetailBatch({
    required this.nomorTransaksi,
    required this.totalBatch,
    required this.totalItems,
  });

  factory PengeluaranItemDetailBatch.fromJson(Map<String, dynamic> json) {
    return PengeluaranItemDetailBatch(
      nomorTransaksi: (json['nomor_transaksi'] ?? '').toString(),
      totalBatch: _parseDouble(json['total_batch']),
      totalItems: _parseInt(json['total_items']),
    );
  }
}

class PengeluaranItemDetailLampiran {
  final int id;
  final String nama;
  final String url;
  final String extension;

  const PengeluaranItemDetailLampiran({
    required this.id,
    required this.nama,
    required this.url,
    required this.extension,
  });

  factory PengeluaranItemDetailLampiran.fromJson(Map<String, dynamic> json) {
    return PengeluaranItemDetailLampiran(
      id: _parseInt(json['id']),
      nama: (json['nama'] ?? '').toString(),
      url: _normalizeUrl((json['url'] ?? '').toString()),
      extension: (json['extension'] ?? '').toString(),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
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
