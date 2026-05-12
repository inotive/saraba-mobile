import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/meta_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';

class OperasionalExpenseCard extends StatelessWidget {
  final OperasionalExpenseItem item;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDetail;

  const OperasionalExpenseCard({
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
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDEAFE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work_outline, color: Color(0xFF5D93E8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                            value: formatCurrency(item.amount),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onTapDetail != null)
                Padding(
                  padding: const EdgeInsets.only(right: 36),
                  child: OutlinedButton(
                    onPressed: onTapDetail,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF7944D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        color: Color(0xFFF7944D),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (onTapEdit != null)
            Positioned(
              top: -6,
              right: -6,
              child: IconButton(
                onPressed: onTapEdit,
                icon: const Icon(Icons.edit_outlined, color: Color(0xFFF7944D)),
                tooltip: 'Edit item',
              ),
            ),
        ],
      ),
    );
  }
}
