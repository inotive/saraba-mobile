class MaterialExpenseItem {
  final String id;
  final String name;
  final int quantity;
  final double total;
  final bool isSelected;
  final bool isCustom;

  const MaterialExpenseItem({
    required this.id,
    required this.name,
    this.quantity = 0,
    this.total = 0,
    this.isSelected = false,
    this.isCustom = false,
  });

  MaterialExpenseItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? total,
    bool? isSelected,
    bool? isCustom,
  }) {
    return MaterialExpenseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
