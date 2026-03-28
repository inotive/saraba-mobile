import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/rab_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/rab_segmented_tab.dart';

class ProjectRabView extends StatefulWidget {
  final ProjectRabSection rab;

  const ProjectRabView({super.key, required this.rab});

  @override
  State<ProjectRabView> createState() => _ProjectRabViewState();
}

class _ProjectRabViewState extends State<ProjectRabView> {
  String selectedTab = 'Pekerjaan';

  @override
  Widget build(BuildContext context) {
    final items = widget.rab.items.where((item) => item.tipe == 'header').toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RabSegmentedTab(
              selectedValue: selectedTab,
              onChanged: (value) {
                setState(() {
                  selectedTab = value;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              selectedTab == 'Pekerjaan'
                  ? 'Pekerjaan (${items.length})'
                  : selectedTab,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
        Expanded(
          child: selectedTab == 'Material'
              ? const _EmptyRabState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return RabItemCard(
                      titleLabel: 'Nama Pekerjaan',
                      title: item.uraian,
                      volume: '${_formatNumber(item.volume)} ${item.satuan}'.trim(),
                      hargaSatuan: _formatCurrency(item.hargaSatuan),
                      jumlahHarga: _formatCurrency(item.jumlah),
                      type: 'pekerjaan',
                    );
                  },
                ),
        ),
      ],
    );
  }
}

String _formatCurrency(String rawValue) {
  final parsedValue = double.tryParse(rawValue) ?? 0;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(parsedValue);
}

String _formatNumber(String rawValue) {
  final parsedValue = double.tryParse(rawValue);
  if (parsedValue == null) {
    return rawValue;
  }

  return NumberFormat.decimalPattern('id_ID').format(parsedValue);
}

class _EmptyRabState extends StatelessWidget {
  const _EmptyRabState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Data material belum tersedia',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
