import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/widgets/project_card.dart';

class PekerjaanPage extends StatelessWidget {
  const PekerjaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerSection(),
        const SizedBox(height: 16),
        _projectSection(),
      ],
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      child: const Text(
        "Pekerjaan",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _projectSection() {
    final projects = [
      {
        "title": "Proyek A",
        "progress": 0.6,
        "nilai": "Rp 500.000.000",
        "pengeluaran": "Rp 120.000.000",
      },
      {
        "title": "Proyek B",
        "progress": 0.3,
        "nilai": "Rp 300.000.000",
        "pengeluaran": "Rp 120.000.000",
      },
      {
        "title": "Proyek C",
        "progress": 0.23,
        "nilai": "Rp 30.000.000",
        "pengeluaran": "Rp 20.000.000",
      },
      {
        "title": "Proyek D",
        "progress": 0.7,
        "nilai": "Rp 3.040.000",
        "pengeluaran": "Rp 50.600.000",
      },
      {
        "title": "Proyek E",
        "progress": 0.546,
        "nilai": "Rp 120.000.000",
        "pengeluaran": "Rp 432.000.000",
      },
      {
        "title": "Proyek F",
        "progress": 0.986,
        "nilai": "Rp 4.430.000",
        "pengeluaran": "Rp 54.064.000",
      },
      {
        "title": "Proyek G",
        "progress": 0.123,
        "nilai": "Rp 734.000.000",
        "pengeluaran": "Rp 853.000.000",
      },
      {
        "title": "Proyek H",
        "progress": 0.856,
        "nilai": "Rp 563.000",
        "pengeluaran": "Rp 223.000",
      },
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: projects.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = projects[index];
            return ProjectCard(
              title: item["title"] as String,
              progress: item["progress"] as double,
              nilai: item["nilai"] as String,
              pengeluaran: item["pengeluaran"] as String,
            );
          },
        ),
      ),
    );
  }
}
