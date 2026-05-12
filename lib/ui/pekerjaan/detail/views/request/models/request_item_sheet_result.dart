import 'request_item.dart';

class RequestItemSheetResult {
  final RequestItem? item;
  final bool isDeleted;

  const RequestItemSheetResult._({this.item, required this.isDeleted});

  factory RequestItemSheetResult.saved(RequestItem item) {
    return RequestItemSheetResult._(item: item, isDeleted: false);
  }

  factory RequestItemSheetResult.deleted() {
    return const RequestItemSheetResult._(isDeleted: true);
  }
}