import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';

import 'operasional_expense_item.dart';
import 'material_attachment_item.dart';

class OperasionalPengeluaranDraft {
  final PengeluaranCategory category;
  final String operasionalName;
  final DateTime date;
  final String createdBy;
  final String note;
  final List<MaterialAttachmentItem> attachments;
  final List<OperasionalExpenseItem> items;

  const OperasionalPengeluaranDraft({
    required this.category,
    required this.operasionalName,
    required this.date,
    required this.createdBy,
    required this.note,
    required this.attachments,
    required this.items,
  });
}
