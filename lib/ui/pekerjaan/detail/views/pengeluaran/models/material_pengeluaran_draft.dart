import 'material_expense_item.dart';
import 'material_attachment_item.dart';

class MaterialPengeluaranDraft {
  final String materialCode;
  final DateTime date;
  final String createdBy;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final List<MaterialExpenseItem> items;

  const MaterialPengeluaranDraft({
    required this.materialCode,
    required this.date,
    required this.createdBy,
    required this.note,
    required this.attachments,
    required this.items,
  });
}
