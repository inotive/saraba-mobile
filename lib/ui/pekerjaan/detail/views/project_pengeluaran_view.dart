import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/pengeluaran_item_card.dart';

class ProjectPengeluaranView extends StatelessWidget {
  const ProjectPengeluaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final groupedData = [
      {
        "date": "12 Maret 2026",
        "items": [
          {
            "title": "Persiapan Lahan",
            "volume": "100 m³",
            "jumlahHarga": "Rp220.000.000",
            "pengeluaran": "Rp90.000.000",
            "persentase": "50%",
          },
          {
            "title": "Pemasangan Batu",
            "volume": "80 m³",
            "jumlahHarga": "Rp180.000.000",
            "pengeluaran": "Rp40.000.000",
            "persentase": "66%",
          },
        ],
      },
      {
        "date": "11 Maret 2026",
        "items": [
          {
            "title": "Pengecoran",
            "volume": "50 m³",
            "jumlahHarga": "Rp150.000.000",
            "pengeluaran": "Rp75.000.000",
            "persentase": "50%",
          },
        ],
      },
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: ListView.builder(
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              final group = groupedData[index];
              final items = group["items"] as List<Map<String, String>>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group["date"] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PengeluaranItemCard(
                        title: item["title"]!,
                        volume: item["volume"]!,
                        jumlahHarga: item["jumlahHarga"]!,
                        pengeluaran: item["pengeluaran"]!,
                        progress: 0.5,
                        persentase: item["persentase"]!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TambahPengeluaranPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7944D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah Pengeluaran",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
