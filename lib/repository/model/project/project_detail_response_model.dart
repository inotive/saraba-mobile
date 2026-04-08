class ProjectDetailResponse {
  final bool success;
  final String message;
  final ProjectDetailData data;

  ProjectDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProjectDetailResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: ProjectDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ProjectDetailData {
  final ProjectOverviewDetail overview;
  final ProjectRabSection rab;
  final ProjectPengeluaranSection pengeluaran;
  final ProjectProgressSection progress;

  ProjectDetailData({
    required this.overview,
    required this.rab,
    required this.pengeluaran,
    required this.progress,
  });

  factory ProjectDetailData.fromJson(Map<String, dynamic> json) {
    return ProjectDetailData(
      overview: ProjectOverviewDetail.fromJson(
        json['overview'] as Map<String, dynamic>,
      ),
      rab: ProjectRabSection.fromJson(json['rab'] as Map<String, dynamic>),
      pengeluaran: ProjectPengeluaranSection.fromJson(
        json['pengeluaran'] as Map<String, dynamic>,
      ),
      progress: ProjectProgressSection.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
    );
  }
}

class ProjectOverviewDetail {
  final int id;
  final String namaProyek;
  final String dinas;
  final String lokasi;
  final String nilaiProyek;
  final String nilaiPengeluaran;
  final String estimasiPengeluaran;
  final double sisaBudget;
  final double budgetPercent;
  final double progress;
  final String status;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String durasiHari;
  final String deskripsi;

  ProjectOverviewDetail({
    required this.id,
    required this.namaProyek,
    required this.dinas,
    required this.lokasi,
    required this.nilaiProyek,
    required this.nilaiPengeluaran,
    required this.estimasiPengeluaran,
    required this.sisaBudget,
    required this.budgetPercent,
    required this.progress,
    required this.status,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.durasiHari,
    required this.deskripsi,
  });

  factory ProjectOverviewDetail.fromJson(Map<String, dynamic> json) {
    return ProjectOverviewDetail(
      id: json['id'] as int? ?? 0,
      namaProyek: json['nama_proyek']?.toString() ?? '',
      dinas: json['dinas']?.toString() ?? '',
      lokasi: json['lokasi']?.toString() ?? '',
      nilaiProyek: json['nilai_proyek']?.toString() ?? '0',
      nilaiPengeluaran: json['nilai_pengeluaran']?.toString() ?? '0',
      estimasiPengeluaran: json['estimasi_pengeluaran']?.toString() ?? '0',
      sisaBudget: _parseDouble(json['sisa_budget']),
      budgetPercent: _parseDouble(json['budget_percent']),
      progress: _parseDouble(json['progress']),
      status: json['status']?.toString() ?? '',
      tanggalMulai: json['tanggal_mulai']?.toString() ?? '',
      tanggalSelesai: json['tanggal_selesai']?.toString() ?? '',
      durasiHari: json['durasi_hari']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
    );
  }
}

class ProjectRabSection {
  final double totalRab;
  final List<ProjectRabItem> items;

  ProjectRabSection({required this.totalRab, required this.items});

  factory ProjectRabSection.fromJson(Map<String, dynamic> json) {
    return ProjectRabSection(
      totalRab: _parseDouble(json['total_rab']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => ProjectRabItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProjectRabItem {
  final int id;
  final String kode;
  final String uraian;
  final String kategori;
  final String tipe;
  final int level;
  final String satuan;
  final String volume;
  final String hargaSatuan;
  final String jumlah;
  final String urutan;
  final double totalChildren;
  final List<ProjectRabItem> children;

  ProjectRabItem({
    required this.id,
    required this.kode,
    required this.uraian,
    required this.kategori,
    required this.tipe,
    required this.level,
    required this.satuan,
    required this.volume,
    required this.hargaSatuan,
    required this.jumlah,
    required this.urutan,
    required this.totalChildren,
    required this.children,
  });

  factory ProjectRabItem.fromJson(Map<String, dynamic> json) {
    return ProjectRabItem(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString() ?? '',
      uraian: json['uraian']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      level: json['level'] as int? ?? 0,
      satuan: json['satuan']?.toString() ?? '',
      volume: json['volume']?.toString() ?? '',
      hargaSatuan: json['harga_satuan']?.toString() ?? '0',
      jumlah: json['jumlah']?.toString() ?? '0',
      urutan: json['urutan']?.toString() ?? '',
      totalChildren: _parseDouble(json['total_children']),
      children: (json['children'] as List<dynamic>? ?? [])
          .map((item) => ProjectRabItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProjectPengeluaranSection {
  final double totalPengeluaran;
  final List<ProjectPengeluaranItem> items;

  ProjectPengeluaranSection({
    required this.totalPengeluaran,
    required this.items,
  });

  factory ProjectPengeluaranSection.fromJson(Map<String, dynamic> json) {
    return ProjectPengeluaranSection(
      totalPengeluaran: _parseDouble(json['total_pengeluaran']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => ProjectPengeluaranItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class ProjectPengeluaranItem {
  final int id;
  final String namaItem;
  final String kategori;
  final String jumlah;
  final String tanggal;
  final String keterangan;
  final ProjectUserSummary user;

  ProjectPengeluaranItem({
    required this.id,
    required this.namaItem,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.user,
  });

  factory ProjectPengeluaranItem.fromJson(Map<String, dynamic> json) {
    return ProjectPengeluaranItem(
      id: json['id'] as int? ?? 0,
      namaItem: json['nama_item']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      jumlah: json['jumlah']?.toString() ?? '0',
      tanggal: json['tanggal']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      user: ProjectUserSummary.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class ProjectProgressSection {
  final double currentProgress;
  final List<ProjectProgressLog> logs;

  ProjectProgressSection({
    required this.currentProgress,
    required this.logs,
  });

  factory ProjectProgressSection.fromJson(Map<String, dynamic> json) {
    return ProjectProgressSection(
      currentProgress: _parseDouble(json['current_progress']),
      logs: (json['logs'] as List<dynamic>? ?? [])
          .map(
            (item) => ProjectProgressLog.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class ProjectProgressLog {
  final int id;
  final String judul;
  final String progressPersen;
  final String tanggal;
  final int? jumlahTukang;
  final String catatan;
  final List<String> fotos;
  final ProjectUserSummary user;
  final String createdAt;

  ProjectProgressLog({
    required this.id,
    required this.judul,
    required this.progressPersen,
    required this.tanggal,
    required this.jumlahTukang,
    required this.catatan,
    required this.fotos,
    required this.user,
    required this.createdAt,
  });

  factory ProjectProgressLog.fromJson(Map<String, dynamic> json) {
    return ProjectProgressLog(
      id: json['id'] as int? ?? 0,
      judul: json['judul']?.toString() ?? '',
      progressPersen: json['progress_persen']?.toString() ?? '0',
      tanggal: json['tanggal']?.toString() ?? '',
      jumlahTukang: _parseNullableInt(json['jumlah_tukang']),
      catatan: json['catatan']?.toString() ?? '',
      fotos: (json['fotos'] as List<dynamic>? ?? [])
          .map(_parsePhotoUrl)
          .where((value) => value.isNotEmpty)
          .toList(),
      user: ProjectUserSummary.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class ProjectUserSummary {
  final int id;
  final String name;

  ProjectUserSummary({required this.id, required this.name});

  factory ProjectUserSummary.fromJson(Map<String, dynamic> json) {
    return ProjectUserSummary(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

String _parsePhotoUrl(dynamic value) {
  if (value is String) {
    return value;
  }

  if (value is Map<String, dynamic>) {
    return value['url']?.toString() ??
        value['foto_url']?.toString() ??
        value['path']?.toString() ??
        '';
  }

  return '';
}
