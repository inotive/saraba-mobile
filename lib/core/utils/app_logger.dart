import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static const String filterTag = 'SARABA_LOG';

  final String tag;

  const AppLogger(this.tag);

  void log(String message) {
    debugPrint('[$filterTag][$tag] $message');
  }

  void request(RequestOptions options) {
    debugPrint('[$filterTag][$tag] ${options.method} ${options.uri}');
    debugPrint('[$filterTag][$tag] Query: ${options.queryParameters}');
    debugPrint('[$filterTag][$tag] Headers: ${options.headers}');
    debugPrint('[$filterTag][$tag] Data: ${options.data}');
  }

  void response(Response<dynamic> response) {
    debugPrint(
      '[$filterTag][$tag] ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    debugPrint('[$filterTag][$tag] Response status: ${response.statusCode}');
    debugPrint('[$filterTag][$tag] Response data: ${response.data}');
  }

  void dioError(DioException error) {
    debugPrint(
      '[$filterTag][$tag][ERROR] ${error.requestOptions.method} ${error.requestOptions.uri}',
    );
    debugPrint('[$filterTag][$tag][ERROR] Message: ${error.message}');
    debugPrint('[$filterTag][$tag][ERROR] Response: ${error.response?.data}');
  }

  void error(String message) {
    debugPrint('[$filterTag][$tag][ERROR] $message');
  }
}
