import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/Request/widgets/category_option_tile.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_category.dart';

class RequestCategorySheet extends StatelessWidget {
  const RequestCategorySheet({super.key});

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
                    'Kategori Request',
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

            ...RequestCategory.values.map(
              (category) => RequestCategoryOptionTile(category: category),
            ),
          ],
        ),
      ),
    );
  }
}
