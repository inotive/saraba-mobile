import 'package:saraba_mobile/repository/model/history_absensi_item_model.dart';
import 'package:saraba_mobile/repository/model/pagination_model.dart';

class HistoryAbsensiResponse {
  final bool success;
  final HistoryAbsensiData data;

  HistoryAbsensiResponse({required this.success, required this.data});

  factory HistoryAbsensiResponse.fromJson(Map<String, dynamic> json) {
    return HistoryAbsensiResponse(
      success: json['success'] ?? false,
      data: HistoryAbsensiData.fromJson(json['data'] ?? {}),
    );
  }
}

class HistoryAbsensiData {
  final List<AbsensiItem> absensis;
  final Pagination pagination;

  HistoryAbsensiData({required this.absensis, required this.pagination});

  factory HistoryAbsensiData.fromJson(Map<String, dynamic> json) {
    return HistoryAbsensiData(
      absensis: (json['absensis'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => AbsensiItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
