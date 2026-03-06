import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

enum AppElevatedButtonSize { xsmall, small, medium, large }

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.text,
    this.fullWidth = true,
    this.onPressed,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 2,
    this.iconRight = false,
    this.size = AppElevatedButtonSize.medium,
    this.isLoading = false,
  });

  final String text;
  final bool fullWidth;
  final AppElevatedButtonSize size;
  final Function()? onPressed;
  final Widget? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final bool iconRight;
  final bool isLoading;

  double get _height {
    switch (size) {
      case AppElevatedButtonSize.xsmall:
        return 28;
      case AppElevatedButtonSize.small:
        return 36;
      case AppElevatedButtonSize.medium:
        return 48;
      case AppElevatedButtonSize.large:
        return 56;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppElevatedButtonSize.xsmall:
        return AppStyles.body10Bold.copyWith(color: textColor ?? Colors.white);
      case AppElevatedButtonSize.small:
        return AppStyles.body12Bold.copyWith(color: textColor ?? Colors.white);
      case AppElevatedButtonSize.medium:
        return AppStyles.body14Bold.copyWith(color: textColor ?? Colors.white);
      case AppElevatedButtonSize.large:
        return AppStyles.body16Bold.copyWith(color: textColor ?? Colors.white);
    }
  }

  Widget child() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: textColor ?? Colors.white,
          strokeWidth: 2,
        ),
      );
    } else {
      return Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!iconRight && icon != null) icon!,
          Text(text, style: _textStyle),
          if (iconRight && icon != null) icon!,
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: elevation,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            color: backgroundColor,
            gradient: backgroundColor == null ? AppColors.linear : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(alignment: Alignment.center, child: child()),
          ),
        ),
      ),
    );
  }
}
