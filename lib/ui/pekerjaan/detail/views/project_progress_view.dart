import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/progress_item_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_progress_page.dart';

class ProjectProgressView extends StatelessWidget {
  const ProjectProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final progressItems = [
      {
        "title": "Persiapan Lahan untuk Pembangunan",
        "jumlahTukang": "10",
        "volume": "100 m³",
        "persentase": "50%",
        "progress": 0.5,
        "images": [
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1497366754035-f200968a6e72",
          "https://images.unsplash.com/photo-1494526585095-c41746248156",
          "https://images.unsplash.com/photo-1500534623283-312aade485b7",
        ],
      },
      {
        "title": "Persiapan Lahan untuk Pembangunan",
        "jumlahTukang": "10",
        "volume": "100 m³",
        "persentase": "50%",
        "progress": 0.5,
        "images": [
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1497366754035-f200968a6e72",
          "https://images.unsplash.com/photo-1494526585095-c41746248156",
          "https://images.unsplash.com/photo-1500534623283-312aade485b7",
        ],
      },
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
          child: Column(
            children: [
              const _DateFilterField(value: "11 Maret 2026"),
              const SizedBox(height: 12),
              const _ProjectDateSummaryCard(
                mulaiProyek: "9 Maret 2026",
                selesai: "9 Maret 2027",
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: progressItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = progressItems[index];
                    return ProgressItemCard(
                      title: item["title"] as String,
                      jumlahTukang: item["jumlahTukang"] as String,
                      volume: item["volume"] as String,
                      persentase: item["persentase"] as String,
                      progress: item["progress"] as double,
                      images: item["images"] as List<String>,
                      onTapArrow: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SizedBox(
            height: 58,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TambahProgressPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7944D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateFilterField extends StatelessWidget {
  final String value;

  const _DateFilterField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1F1F1F)),
      ),
    );
  }
}

class _ProjectDateSummaryCard extends StatelessWidget {
  final String mulaiProyek;
  final String selesai;

  const _ProjectDateSummaryCard({
    required this.mulaiProyek,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _row("Mulai Proyek", mulaiProyek),
          const SizedBox(height: 10),
          _row("Selesai", selesai),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B2A4A),
          ),
        ),
      ],
    );
  }
}
