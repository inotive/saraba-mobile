import 'material_expense_item.dart';

class MaterialItemSheetResult {
  final MaterialExpenseItem? item;
  final bool isDeleted;

  const MaterialItemSheetResult._({this.item, required this.isDeleted});

  factory MaterialItemSheetResult.saved(MaterialExpenseItem item) {
    return MaterialItemSheetResult._(item: item, isDeleted: false);
  }

  factory MaterialItemSheetResult.deleted() {
    return const MaterialItemSheetResult._(isDeleted: true);
  }
}
