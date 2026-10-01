import 'package:flutter/material.dart';
import 'package:saraba_mobile/core/utils/format_utils.dart';
import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/widgets/turnamen_empty_state.dart';

class TurnamenPengeluaranView extends StatelessWidget {
  final TurnamenPengeluaran pengeluaran;
  final Future<void> Function() onRefresh;

  const TurnamenPengeluaranView({
    super.key,
    required this.pengeluaran,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final pemain = pengeluaran.pemain;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: pemain.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                TurnamenEmptyState(message: 'Belum ada pemain di turnamen ini'),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: pemain.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _SummaryHeader(
                    totalPemain: pemain.length,
                    totalPengeluaran: pengeluaran.totalPengeluaran,
                  );
                }

                return _PemainPengeluaranCard(pemain: pemain[index - 1]);
              },
            ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int totalPemain;
  final double totalPengeluaran;

  const _SummaryHeader({
    required this.totalPemain,
    required this.totalPengeluaran,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Total Pemain : $totalPemain orang",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
        Text(
          formatRupiah(totalPengeluaran),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF7944D),
          ),
        ),
      ],
    );
  }
}

/// Kartu per pemain yang bisa dibuka untuk melihat item pengeluarannya.
class _PemainPengeluaranCard extends StatelessWidget {
  final TurnamenPengeluaranPemain pemain;

  const _PemainPengeluaranCard({required this.pemain});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: const Color(0xFFF7944D),
          collapsedIconColor: const Color(0xFF8C8C8C),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pemain.namaPemain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B2A4A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3FF),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFBBD8FF)),
                      ),
                      child: Text(
                        "${pemain.itemsCount} Data Pengeluaran",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E88FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatRupiah(pemain.total),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B2A4A),
                ),
              ),
            ],
          ),
          children: [
            if (pemain.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Belum ada pengeluaran',
                  style: TextStyle(fontSize: 13, color: Color(0xFF8C8C8C)),
                ),
              )
            else
              for (final item in pemain.items) _ItemRow(item: item),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final TurnamenPengeluaranItem item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final qty = item.satuan.isEmpty ? '${item.qty}' : '${item.qty} ${item.satuan}';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaItem,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "$qty × ${formatRupiah(item.hargaSatuan)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatRupiah(item.total),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}
