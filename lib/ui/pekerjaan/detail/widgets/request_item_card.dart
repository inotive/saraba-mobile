import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/meta_column.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item.dart';

class RequestItemCard extends StatelessWidget {
  final RequestItem item;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDetail;

  const RequestItemCard({
    super.key,
    required this.item,
    this.onTapEdit,
    this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Row(
                      children: [
                        Expanded(
                          child: MetaColumn(
                            label: 'Nama Item',
                            value: item.name,
                          ),
                        ),
                        Expanded(
                          child: MetaColumn(
                            label: 'Qty',
                            value: item.quantity.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga Satuan',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              Text(
                                'Harga Total',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatCurrency(item.unitPrice),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              Text(
                                formatCurrency(item.total),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                            ],
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
