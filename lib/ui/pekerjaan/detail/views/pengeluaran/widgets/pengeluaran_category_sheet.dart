import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/category_option_tile.dart';

class PengeluaranCategorySheet extends StatelessWidget {
  const PengeluaranCategorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Kategori Pengeluaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...PengeluaranCategory.values.map(
              (category) => CategoryOptionTile(category: category),
            ),
          ],
        ),
      ),
    );
  }
}
