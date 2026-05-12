class RequestItemInput {
  final String namaItem;
  final double qty;
  final String satuan;
  final double hargaSatuan;

  const RequestItemInput({
    required this.namaItem,
    required this.qty,
    required this.satuan,
    required this.hargaSatuan,
  });

  Map<String, dynamic> toJson() {
    return {
      "nama_item": namaItem,
      "qty": qty,
      "satuan": satuan,
      "harga_satuan": hargaSatuan,
    };
  }
}
