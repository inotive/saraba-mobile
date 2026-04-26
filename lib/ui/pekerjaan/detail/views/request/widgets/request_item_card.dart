import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestItemCard extends StatelessWidget {
  final String itemName;
  final int qty;
  final double price;
  final double total;

  const RequestItemCard({
    super.key,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Item',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8C8C8C)),
                ),

                Text(
                  itemName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 6),

                Text('Harga Satuan', style: const TextStyle(fontSize: 11)),

                Text(
                  currency.format(price),
                  style: const TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text('Harga Total', style: const TextStyle(fontSize: 11)),

                Text(
                  currency.format(total),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Qty',
                style: TextStyle(fontSize: 11, color: Color(0xFF8C8C8C)),
              ),
              Text(
                qty.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
