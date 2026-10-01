import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/widgets/pemain_detail_sheet.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/widgets/turnamen_empty_state.dart';

class TurnamenPemainView extends StatelessWidget {
  final List<TurnamenPemain> pemain;
  final Future<void> Function() onRefresh;

  const TurnamenPemainView({
    super.key,
    required this.pemain,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
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
                  return Text(
                    "Total Pemain : ${pemain.length} orang",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1F1F),
                    ),
                  );
                }

                final item = pemain[index - 1];
                return _PemainCard(
                  pemain: item,
                  onTap: () => showPemainDetailSheet(context, item),
                );
              },
            ),
    );
  }
}

class _PemainCard extends StatelessWidget {
  final TurnamenPemain pemain;
  final VoidCallback onTap;

  const _PemainCard({required this.pemain, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final rekening = [
      pemain.noRekening,
      pemain.namaBank,
    ].where((e) => e.isNotEmpty).join(' · ');

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF2A4FA2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pemain.namaPemain,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B2A4A),
                    ),
                  ),
                  if (pemain.jenisKelamin.isNotEmpty)
                    _MutedLine(pemain.jenisKelamin),
                  if (pemain.nomorHp.isNotEmpty) _MutedLine(pemain.nomorHp),
                  if (pemain.email.isNotEmpty) _MutedLine(pemain.email),
                  if (rekening.isNotEmpty) _MutedLine(rekening),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF8C8C8C)),
          ],
        ),
      ),
    );
  }
}

class _MutedLine extends StatelessWidget {
  final String text;

  const _MutedLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
      ),
    );
  }
}
