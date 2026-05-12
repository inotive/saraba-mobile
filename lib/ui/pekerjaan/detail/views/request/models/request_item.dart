class RequestItem {
  final String id;
  final String name;
  final int quantity;
  final double unitPrice;

  const RequestItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  RequestItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? unitPrice,
  }) {
    return RequestItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
