import 'material_attachment_item.dart';

class OperasionalExpenseItem {
  final String id;
  final String name;
  final int quantity;
  final double amount;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final bool isSelected;
  final bool isCustom;

  const OperasionalExpenseItem({
    required this.id,
    required this.name,
    this.quantity = 0,
    required this.amount,
    required this.note,
    required this.attachments,
    this.isSelected = false,
    this.isCustom = false,
  });

  OperasionalExpenseItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? amount,
    String? note,
    List<MaterialAttachmentItem>? attachments,
    bool? isSelected,
    bool? isCustom,
  }) {
    return OperasionalExpenseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      attachments: attachments ?? this.attachments,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
