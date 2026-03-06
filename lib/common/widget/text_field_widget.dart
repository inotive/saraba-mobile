import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class AppTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final String? initialValue;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final bool obscureText;

  const AppTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.minLines,
    this.onChanged,
    this.maxLines,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.initialValue,
    this.onTap,
    this.inputFormatters,
    this.errorText,
    this.obscureText = false,
  });

  Widget? _buildIcon(Widget? icon) {
    if (icon == null) return null;
    return icon is Icon
        ? icon
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: icon,
          );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((label ?? '').isNotEmpty)
          Text(
            label!,
            style: AppStyles.body12Medium.copyWith(color: AppColors.grey700),
          ),
        const SizedBox(height: 6),
        TextFormField(
          style: AppStyles.body14Regular.copyWith(color: AppColors.neutral900),
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          obscureText: obscureText,
          obscuringCharacter: '•',
          onTap: onTap,
          keyboardType: keyboardType,
          cursorColor: AppColors.darkBlueButton,
          minLines: minLines,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.body14Regular.copyWith(
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: AppColors.neutral100,
            prefixIcon: _buildIcon(prefixIcon),
            suffixIcon: _buildIcon(suffixIcon),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.red500 : AppColors.neutral300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.red500 : AppColors.neutral300,
                width: 1.2,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          Text(
            errorText!,
            style: AppStyles.body12Regular.copyWith(color: AppColors.red500),
          ),
        ],
      ],
    );
  }
}
