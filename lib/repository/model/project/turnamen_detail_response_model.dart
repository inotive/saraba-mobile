/// Respons `GET /sport-stations/{id}`: overview, pemain, dan pengeluaran per pemain.
class TurnamenDetailResponse {
  final bool success;
  final String message;
  final TurnamenDetailData data;

  TurnamenDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TurnamenDetailResponse.fromJson(Map<String, dynamic> json) {
    return TurnamenDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TurnamenDetailData.fromJson(json['data'] ?? const {}),
    );
  }
}

class TurnamenDetailData {
  final TurnamenOverview overview;
  final List<TurnamenPemain> pemain;
  final TurnamenPengeluaran pengeluaran;

  TurnamenDetailData({
    required this.overview,
    required this.pemain,
    required this.pengeluaran,
  });

  factory TurnamenDetailData.fromJson(Map<String, dynamic> json) {
    return TurnamenDetailData(
      overview: TurnamenOverview.fromJson(json['overview'] ?? const {}),
      pemain: (json['pemain'] as List<dynamic>? ?? const [])
          .map((item) => TurnamenPemain.fromJson(item as Map<String, dynamic>))
          .toList(),
      pengeluaran: TurnamenPengeluaran.fromJson(json['pengeluaran'] ?? const {}),
    );
  }
}

class TurnamenOverview {
  final int id;
  final String namaTurnamen;
  final String tanggalMulai;
  final String lapangan;
  final String keterangan;
  final int totalPemain;
  final double totalPengeluaran;

  TurnamenOverview({
    required this.id,
    required this.namaTurnamen,
    required this.tanggalMulai,
    required this.lapangan,
    required this.keterangan,
    required this.totalPemain,
    required this.totalPengeluaran,
  });

  factory TurnamenOverview.fromJson(Map<String, dynamic> json) {
    return TurnamenOverview(
      id: _toInt(json['id']),
      namaTurnamen: _toStr(json['nama_turnamen']),
      tanggalMulai: _toStr(json['tanggal_mulai']),
      lapangan: _toStr(json['lapangan']),
      keterangan: _toStr(json['keterangan']),
      totalPemain: _toInt(json['total_pemain']),
      totalPengeluaran: _toDouble(json['total_pengeluaran']),
    );
  }
}

class TurnamenPemain {
  final int id;
  final String namaPemain;
  final String jenisKelamin;
  final String nomorHp;
  final String email;
  final String namaBank;
  final String noRekening;
  final String status;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String kelurahan;
  final String alamatLengkap;

  TurnamenPemain({
    required this.id,
    required this.namaPemain,
    required this.jenisKelamin,
    required this.nomorHp,
    required this.email,
    required this.namaBank,
    required this.noRekening,
    required this.status,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.kelurahan,
    required this.alamatLengkap,
  });

  factory TurnamenPemain.fromJson(Map<String, dynamic> json) {
    return TurnamenPemain(
      id: _toInt(json['id']),
      namaPemain: _toStr(json['nama_pemain']),
      jenisKelamin: _toStr(json['jenis_kelamin']),
      nomorHp: _toStr(json['nomor_hp']),
      email: _toStr(json['email']),
      namaBank: _toStr(json['nama_bank']),
      noRekening: _toStr(json['no_rekening']),
      status: _toStr(json['status']),
      provinsi: _toStr(json['provinsi']),
      kabupaten: _toStr(json['kabupaten']),
      kecamatan: _toStr(json['kecamatan']),
      kelurahan: _toStr(json['kelurahan']),
      alamatLengkap: _toStr(json['alamat_lengkap']),
    );
  }
}

class TurnamenPengeluaran {
  final double totalPengeluaran;
  final List<TurnamenPengeluaranPemain> pemain;

  TurnamenPengeluaran({required this.totalPengeluaran, required this.pemain});

  factory TurnamenPengeluaran.fromJson(Map<String, dynamic> json) {
    return TurnamenPengeluaran(
      totalPengeluaran: _toDouble(json['total_pengeluaran']),
      pemain: (json['pemain'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                TurnamenPengeluaranPemain.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class TurnamenPengeluaranPemain {
  final int pemainId;
  final String namaPemain;
  final int itemsCount;
  final double total;
  final List<TurnamenPengeluaranItem> items;

  TurnamenPengeluaranPemain({
    required this.pemainId,
    required this.namaPemain,
    required this.itemsCount,
    required this.total,
    required this.items,
  });

  factory TurnamenPengeluaranPemain.fromJson(Map<String, dynamic> json) {
    return TurnamenPengeluaranPemain(
      pemainId: _toInt(json['pemain_id']),
      namaPemain: _toStr(json['nama_pemain']),
      itemsCount: _toInt(json['items_count']),
      total: _toDouble(json['total']),
      items: (json['items'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                TurnamenPengeluaranItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class TurnamenPengeluaranItem {
  final int id;
  final String namaItem;
  final int qty;
  final String satuan;
  final double hargaSatuan;
  final double total;

  TurnamenPengeluaranItem({
    required this.id,
    required this.namaItem,
    required this.qty,
    required this.satuan,
    required this.hargaSatuan,
    required this.total,
  });

  factory TurnamenPengeluaranItem.fromJson(Map<String, dynamic> json) {
    return TurnamenPengeluaranItem(
      id: _toInt(json['id']),
      namaItem: _toStr(json['nama_item']),
      qty: _toInt(json['qty']),
      satuan: _toStr(json['satuan']),
      hargaSatuan: _toDouble(json['harga_satuan']),
      total: _toDouble(json['total']),
    );
  }
}

double _toDouble(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('${value ?? ''}') ?? 0;

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('${value ?? ''}') ?? 0;

String _toStr(dynamic value) => value?.toString() ?? '';
