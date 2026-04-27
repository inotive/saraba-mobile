import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/mappers/pengeluaran_category_extension.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';

class CategoryOptionTile extends StatelessWidget {
  final PengeluaranCategory category;

  const CategoryOptionTile({super.key, required this.category});

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
                  category.categorySheetIconAsset,
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