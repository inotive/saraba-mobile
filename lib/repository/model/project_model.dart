enum ProjectType { proyek, turnamen }

/// Filter jenis item pada daftar proyek & turnamen (nilai `name` dikirim sebagai parameter `type`).
enum PekerjaanFilter { all, proyek, turnamen }

extension PekerjaanFilterX on PekerjaanFilter {
  String get apiValue => name;

  String get label {
    switch (this) {
      case PekerjaanFilter.all:
        return 'Semua';
      case PekerjaanFilter.proyek:
        return 'Proyek';
      case PekerjaanFilter.turnamen:
        return 'Turnamen';
    }
  }

  String get emptyMessage {
    switch (this) {
      case PekerjaanFilter.all:
        return 'Belum ada proyek atau turnamen';
      case PekerjaanFilter.proyek:
        return 'Belum ada data proyek';
      case PekerjaanFilter.turnamen:
        return 'Belum ada data turnamen';
    }
  }
}

class ProjectModel {
  final String id;
  final String title;
  final double progress;
  final String nilai;
  final String pengeluaran;
  final ProjectType type;
  final int jumlahPemain;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.progress,
    required this.nilai,
    required this.pengeluaran,
    this.type = ProjectType.proyek,
    this.jumlahPemain = 0,
  });

  bool get isTurnamen => type == ProjectType.turnamen;
}
