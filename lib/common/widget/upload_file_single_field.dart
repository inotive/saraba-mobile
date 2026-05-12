import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saraba_mobile/common/theme/theme.dart';

class UploadFileSingleField<T> extends StatefulWidget {
  final T? value;
  final String title;
  final String subtitle;
  final String? label;
  final String? initialFileName;
  final VoidCallback? onPreviewInitial;
  final FormFieldValidator<T>? validator;
  final Future<T?> Function()? onAdd;
  final Function()? onDelete;

  const UploadFileSingleField({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.onAdd,
    this.onDelete,
    this.label,
    this.validator,
    this.initialFileName,
    this.onPreviewInitial,
  });

  @override
  State<UploadFileSingleField<T>> createState() =>
      _UploadFileSingleFieldState<T>();
}

class _UploadFileSingleFieldState<T> extends State<UploadFileSingleField<T>> {
  final _formFieldKey = GlobalKey<FormFieldState<T>>();

  String _getFileName(dynamic file) {
    if (file is String) {
      return file.split('/').last;
    } else if (file is File) {
      return file.path.split('/').last;
    }
    return 'Lampiran';
  }

  String _getExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  Widget _buildFileIcon(String fileName) {
    final ext = _getExtension(fileName);

    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      return const Icon(Icons.image_outlined, size: 28);
    } else if (ext == 'pdf') {
      return const Icon(Icons.description_outlined, size: 28);
    } else if (['doc', 'docx'].contains(ext)) {
      return const Icon(Icons.description_outlined, size: 28);
    }

    return const Icon(Icons.attach_file_outlined, size: 28);
  }

  Widget _buildFileItem({
    required String fileName,
    required VoidCallback? onDelete,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          _buildFileIcon(fileName),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                fileName,
                style: AppStyles.body14SemiBold.copyWith(
                  color: AppColors.primary500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.close, size: 18),
              // child: Assets.icon.crossRedIcon.image(width: 18, height: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(FormFieldState<T> field) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: widget.onAdd != null
            ? () async {
                final res = await widget.onAdd?.call();
                if (res != null) {
                  field.didChange(res);
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary400),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.file_upload_outlined, size: 16),
              // Assets.icon.uploadIcon.image(width: 16, height: 16),
              const SizedBox(width: 6),
              Text(
                "Upload",
                style: AppStyles.body14Medium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: _formFieldKey,
      initialValue: widget.value,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final file = field.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: AppStyles.body14Medium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: AppStyles.body12Regular.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 8),

            if (file != null)
              _buildFileItem(
                fileName: _getFileName(file),
                onDelete: () {
                  widget.onDelete?.call();
                  field.didChange(null);
                },
              )
            else if (widget.initialFileName != null)
              _buildFileItem(
                fileName: widget.initialFileName!,
                onDelete: () {
                  widget.onDelete?.call();
                  field.didChange(null);
                },
                onTap: widget.onPreviewInitial,
              )
            else
              _buildUploadButton(field),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
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
