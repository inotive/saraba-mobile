
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class AppRupiahTextFormField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final Function()? onTap;
  final Function(int)? onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppRupiahTextFormField({
    super.key,
    this.label,
    this.hintText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  State<AppRupiahTextFormField> createState() => _AppRupiahTextFormFieldState();
}

class _AppRupiahTextFormFieldState extends State<AppRupiahTextFormField> {
  bool _isFormatting = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatValue);
    super.dispose();
  }

  void _formatValue() {
    if (_isFormatting) return;
    _isFormatting = true;

    String text = widget.controller.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      widget.controller.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      _isFormatting = false;
      return;
    }

    final number = int.tryParse(text) ?? 0;
    final formatted = _formatRupiah(number.toDouble());

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    if (widget.onChanged != null) {
      widget.onChanged!(number);
    }

    _isFormatting = false;
  }

  String _formatRupiah(double value) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return format.format(value).trim();
  }

  Widget? _buildIcon(Widget? icon) {
    if (icon == null) return null;
    return icon is Icon
        ? icon
        : Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if ((widget.label ?? '').isNotEmpty)
          Text(
            widget.label!,
            style: AppStyles.body12Medium.copyWith(color: AppColors.grey700),
          ),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTap: widget.onTap,
          // cursorColor: AppColors.primary500,
          autovalidateMode: widget.autovalidateMode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppStyles.body14Regular.copyWith(
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: AppColors.neutral100,

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: Text(
                "Rp",
                style: AppStyles.body14Regular.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),

            suffixIcon: _buildIcon(widget.suffixIcon),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral300, width: 1),
            ),

            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(color: AppColors.primary500, width: 1.2),
            // ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.red500, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.red500, width: 1.2),
            ),

            errorStyle: AppStyles.body12Regular.copyWith(
              color: AppColors.red500,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
