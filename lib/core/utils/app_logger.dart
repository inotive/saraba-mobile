import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum AppLogLevel { info, request, response, error }

class AppLogEntry {
  final DateTime timestamp;
  final String tag;
  final AppLogLevel level;
  final String message;

  const AppLogEntry({
    required this.timestamp,
    required this.tag,
    required this.level,
    required this.message,
  });
}

class AppLogger {
  static const String filterTag = 'SARABA_LOG';
  static const int _maxEntries = 500;
  static final ValueNotifier<List<AppLogEntry>> entries =
      ValueNotifier<List<AppLogEntry>>(<AppLogEntry>[]);

  final String tag;

  const AppLogger(this.tag);

  void log(String message) {
    _append(AppLogLevel.info, message);
    debugPrint('[$filterTag][$tag] $message');
  }

  void request(RequestOptions options) {
    final message = [
      '${options.method} ${options.uri}',
      'Query: ${options.queryParameters}',
      'Headers: ${options.headers}',
      'Data: ${options.data}',
    ].join('\n');

    _append(AppLogLevel.request, message);
    debugPrint('[$filterTag][$tag] ${options.method} ${options.uri}');
    debugPrint('[$filterTag][$tag] Query: ${options.queryParameters}');
    debugPrint('[$filterTag][$tag] Headers: ${options.headers}');
    debugPrint('[$filterTag][$tag] Data: ${options.data}');
  }

  void response(Response<dynamic> response) {
    final message = [
      '${response.requestOptions.method} ${response.requestOptions.uri}',
      'Response status: ${response.statusCode}',
      'Response data: ${response.data}',
    ].join('\n');

    _append(AppLogLevel.response, message);
    debugPrint(
      '[$filterTag][$tag] ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    debugPrint('[$filterTag][$tag] Response status: ${response.statusCode}');
    debugPrint('[$filterTag][$tag] Response data: ${response.data}');
  }

  void dioError(DioException error) {
    final message = [
      '${error.requestOptions.method} ${error.requestOptions.uri}',
      'Message: ${error.message}',
      'Response: ${error.response?.data}',
    ].join('\n');

    _append(AppLogLevel.error, message);
    debugPrint(
      '[$filterTag][$tag][ERROR] ${error.requestOptions.method} ${error.requestOptions.uri}',
    );
    debugPrint('[$filterTag][$tag][ERROR] Message: ${error.message}');
    debugPrint('[$filterTag][$tag][ERROR] Response: ${error.response?.data}');
  }

  void error(String message) {
    _append(AppLogLevel.error, message);
    debugPrint('[$filterTag][$tag][ERROR] $message');
  }

  static void clear() {
    entries.value = <AppLogEntry>[];
  }

  static String exportText() {
    return entries.value
        .map((entry) {
          final time = entry.timestamp.toIso8601String();
          return '[$filterTag][$time][${entry.tag}][${entry.level.name.toUpperCase()}] ${entry.message}';
        })
        .join('\n\n');
  }

  void _append(AppLogLevel level, String message) {
    final nextEntries = List<AppLogEntry>.from(entries.value)
      ..add(
        AppLogEntry(
          timestamp: DateTime.now(),
          tag: tag,
          level: level,
          message: message,
        ),
      );

    if (nextEntries.length > _maxEntries) {
      nextEntries.removeRange(0, nextEntries.length - _maxEntries);
    }

    entries.value = nextEntries;
  }
}
