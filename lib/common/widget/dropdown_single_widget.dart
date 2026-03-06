import 'package:flutter/material.dart';

import '../../../common/theme/theme.dart';

class CustomBottomSheetDropdownSingle<T> extends StatefulWidget {
  final String? label;
  final String? labelBottomSheet;
  final TextStyle? labelStyle;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String Function(T) labelFn;
  final String hintText;
  final String searchHintText;
  final bool hasBorder;
  final bool isSearchable;
  final Widget Function(T, bool) itemBuilder;
  final FormFieldValidator<T>? validator;
  final bool readOnly;

  /// diganti dari `options` menjadi asyncItems
  final Future<List<T>> Function(String query) asyncItems;

  const CustomBottomSheetDropdownSingle({
    super.key,
    this.label,
    this.hintText = 'Pilih salah satu',
    this.searchHintText = 'Cari ...',
    this.selectedValue,
    this.labelBottomSheet,
    required this.onChanged,
    required this.labelFn,
    required this.asyncItems,
    this.isSearchable = false,
    this.labelStyle,
    this.hasBorder = true,
    required this.itemBuilder,
    this.validator,
    this.readOnly = false,
  });

  @override
  State<CustomBottomSheetDropdownSingle<T>> createState() =>
      _CustomBottomSheetDropdownState<T>();
}

class _CustomBottomSheetDropdownState<T>
    extends State<CustomBottomSheetDropdownSingle<T>> {
  void _showBottomSheet(BuildContext context, FormFieldState<T> field) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        T? tempSelectedValue = widget.selectedValue;
        String query = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder<List<T>>(
              future: widget.asyncItems(query),
              builder: (context, snapshot) {
                final options = snapshot.data ?? [];

                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.labelBottomSheet ?? widget.label ?? '-',
                              style: AppStyles.body18Medium.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral200),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (options.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Tidak ada data"),
                        )
                      else
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: options.map((item) {
                              final isSelected = item == tempSelectedValue;
                              return GestureDetector(
                                onTap: () => Navigator.pop(context, item),
                                child: widget.itemBuilder(item, isSelected),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );

    if (result != null) {
      field.didChange(result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = widget.selectedValue != null
        ? widget.labelFn(widget.selectedValue as T)
        : null;

    return FormField<T>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.selectedValue,
      validator: widget.validator,
      builder: (FormFieldState<T> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (widget.label != null)
              Text(
                widget.label ?? '',
                style:
                    widget.labelStyle ??
                    AppStyles.body12Medium.copyWith(color: AppColors.grey700),
              ),
            GestureDetector(
              onTap: widget.readOnly
                  ? null
                  : () => _showBottomSheet(context, field),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  border: widget.hasBorder
                      ? Border.all(color: AppColors.neutral200)
                      : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedLabel ?? widget.hintText,
                        style: AppStyles.body13Regular.copyWith(
                          color: selectedLabel == null
                              ? AppColors.grey500
                              : AppColors.grey300,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  field.errorText ?? '',
                  style: AppStyles.body12Regular.copyWith(
                    color: AppColors.red500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
