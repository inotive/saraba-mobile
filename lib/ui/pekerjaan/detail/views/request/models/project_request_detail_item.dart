class ProjectRequestDetailItem {
  final String namaItem;
  final double qty;
  final String satuan;
  final double hargaSatuan;

  const ProjectRequestDetailItem({
    required this.namaItem,
    required this.qty,
    required this.satuan,
    required this.hargaSatuan,
  });

  double get total => qty * hargaSatuan;

  factory ProjectRequestDetailItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProjectRequestDetailItem(
      namaItem: (json['nama_item'] ?? '').toString(),
      qty: double.tryParse(json['qty'].toString()) ?? 0,
      satuan: (json['satuan'] ?? '').toString(),
      hargaSatuan:
          double.tryParse(json['harga_satuan'].toString()) ?? 0,
    );
  }
}