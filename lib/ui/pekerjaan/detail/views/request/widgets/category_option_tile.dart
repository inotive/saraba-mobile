import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/mappers/request_category_extension.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_category.dart';

class RequestCategoryOptionTile extends StatelessWidget {
  final RequestCategory category;

  const RequestCategoryOptionTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pop(context, category),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Image.asset(
                  category.iconAsset,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
