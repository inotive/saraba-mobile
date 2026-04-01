class SubmitPengeluaranResponse {
  final bool success;
  final String message;
  final SubmittedPengeluaranBatch? data;

  SubmitPengeluaranResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubmitPengeluaranResponse.fromJson(Map<String, dynamic> json) {
    return SubmitPengeluaranResponse(
      success:
          json['success'] == true || json['status']?.toString() == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? SubmittedPengeluaranBatch.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SubmittedPengeluaranBatch {
  final String nomorTransaksi;
  final int count;
  final List<SubmittedPengeluaranItem> items;
  final double totalBatch;

  SubmittedPengeluaranBatch({
    required this.nomorTransaksi,
    required this.count,
    required this.items,
    required this.totalBatch,
  });

  factory SubmittedPengeluaranBatch.fromJson(Map<String, dynamic> json) {
    return SubmittedPengeluaranBatch(
      nomorTransaksi: json['nomor_transaksi']?.toString() ?? '',
      count: json['count'] as int? ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => SubmittedPengeluaranItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalBatch: _parseDouble(json['total_batch']),
    );
  }
}

class SubmittedPengeluaranItem {
  final int id;
  final String namaItem;
  final int kuantitas;
  final String jumlah;

  SubmittedPengeluaranItem({
    required this.id,
    required this.namaItem,
    required this.kuantitas,
    required this.jumlah,
  });

  factory SubmittedPengeluaranItem.fromJson(Map<String, dynamic> json) {
    return SubmittedPengeluaranItem(
      id: json['id'] as int? ?? 0,
      namaItem: json['nama_item']?.toString() ?? '',
      kuantitas: json['kuantitas'] as int? ?? 0,
      jumlah: json['jumlah']?.toString() ?? '0',
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}
