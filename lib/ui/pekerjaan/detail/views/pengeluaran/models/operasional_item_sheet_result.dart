import 'operasional_expense_item.dart';

class OperasionalItemSheetResult {
  final OperasionalExpenseItem? item;
  final bool isDeleted;

  const OperasionalItemSheetResult._({this.item, required this.isDeleted});

  factory OperasionalItemSheetResult.saved(OperasionalExpenseItem item) {
    return OperasionalItemSheetResult._(item: item, isDeleted: false);
  }

  factory OperasionalItemSheetResult.deleted() {
    return const OperasionalItemSheetResult._(isDeleted: true);
  }
}
