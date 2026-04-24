import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

const bool _enableAliceInRelease = bool.fromEnvironment(
  'ENABLE_SHAKE_LOGS',
  defaultValue: false,
);

class AliceDebug {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final Alice _alice = Alice(navigatorKey: navigatorKey);

  static bool get isEnabled => !kReleaseMode || _enableAliceInRelease;

  static void attachToDio(Dio dio) {
    if (!isEnabled) {
      return;
    }

    dio.interceptors.add(_alice.getDioInterceptor());
  }

  static void showInspector() {
    if (!isEnabled) {
      return;
    }

    _alice.showInspector();
  }
}
