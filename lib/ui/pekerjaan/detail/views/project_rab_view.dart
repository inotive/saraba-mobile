import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/rab_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/rab_segmented_tab.dart';

class ProjectRabView extends StatefulWidget {
  const ProjectRabView({super.key});

  @override
  State<ProjectRabView> createState() => _ProjectRabViewState();
}

class _ProjectRabViewState extends State<ProjectRabView> {
  String selectedTab = 'Pekerjaan';

  final List<Map<String, String>> pekerjaanItems = const [
    {
      'titleLabel': 'Nama Pekerjaan',
      'title': 'Persiapan Lahan',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'pekerjaan',
    },
    {
      'titleLabel': 'Nama Pekerjaan',
      'title': 'Persiapan Lahan',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'pekerjaan',
    },
    {
      'titleLabel': 'Nama Pekerjaan',
      'title': 'Persiapan Lahan',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'pekerjaan',
    },
    {
      'titleLabel': 'Nama Pekerjaan',
      'title': 'Persiapan Lahan',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'pekerjaan',
    },
  ];

  final List<Map<String, String>> materialItems = const [
    {
      'titleLabel': 'Nama Material',
      'title': 'Pasir Hitam Kristal',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'material',
    },
    {
      'titleLabel': 'Nama Material',
      'title': 'Semen Bangunan AA',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'material',
    },
    {
      'titleLabel': 'Nama Material',
      'title': 'Batu Bata Merah',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'material',
    },
    {
      'titleLabel': 'Nama Material',
      'title': 'Bahan Bakar Minyak',
      'volume': '100 m³',
      'hargaSatuan': 'Rp120.000.000',
      'jumlahHarga': 'Rp220.000.000',
      'type': 'material',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final items = selectedTab == 'Pekerjaan' ? pekerjaanItems : materialItems;

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
              selectedTab,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return RabItemCard(
                titleLabel: item['titleLabel']!,
                title: item['title']!,
                volume: item['volume']!,
                hargaSatuan: item['hargaSatuan']!,
                jumlahHarga: item['jumlahHarga']!,
                type: item['type']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
