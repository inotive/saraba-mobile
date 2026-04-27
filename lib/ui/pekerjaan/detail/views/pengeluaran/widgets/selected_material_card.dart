import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/meta_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';

class SelectedMaterialItemCard extends StatelessWidget {
  final MaterialExpenseItem item;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDetail;

  const SelectedMaterialItemCard({
    super.key,
    required this.item,
    this.onTapEdit,
    this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: Color(0xFF5D93E8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: onTapEdit != null || onTapDetail != null ? 118 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Material',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: MetaColumn(
                              label: 'Jumlah',
                              value: item.quantity.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: MetaColumn(
                              label: 'Total',
                              value: formatCurrency(item.total),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (onTapEdit != null || onTapDetail != null)
            Positioned(
              top: 2,
              right: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onTapDetail != null)
                    OutlinedButton(
                      onPressed: onTapDetail,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF7944D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(
                          color: Color(0xFFF7944D),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (onTapDetail != null && onTapEdit != null)
                    const SizedBox(width: 4),
                  if (onTapEdit != null)
                    IconButton(
                      onPressed: onTapEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFF7944D),
                        size: 20,
                      ),
                      tooltip: 'Edit item',
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
