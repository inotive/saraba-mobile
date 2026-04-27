class RequestApprovalItem {
  final int id;
  final String namaItem;
  final int qty;
  final String satuan;
  final int hargaSatuan;
  final int total;

  const RequestApprovalItem({
    required this.id,
    required this.namaItem,
    required this.qty,
    required this.satuan,
    required this.hargaSatuan,
    required this.total,
  });

  factory RequestApprovalItem.fromJson(Map<String, dynamic> json) {
    return RequestApprovalItem(
      id: _parseInt(json['id']),
      namaItem: json['nama_item'] ?? '',
      qty: _parseInt(json['qty']),
      satuan: json['satuan'] ?? '',
      hargaSatuan: _parseInt(json['harga_satuan']),
      total: _parseInt(json['total']),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
