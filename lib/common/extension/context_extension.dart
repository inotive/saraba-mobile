import 'package:flutter/material.dart';

extension CustomBuildContext on BuildContext {
  double bottomInset() => MediaQuery.of(this).padding.bottom;
}
