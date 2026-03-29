class SubmitPengeluaranResponse {
  final bool success;
  final String message;
  final SubmittedPengeluaranItem? data;

  SubmitPengeluaranResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubmitPengeluaranResponse.fromJson(Map<String, dynamic> json) {
    return SubmitPengeluaranResponse(
      success:
          json['success'] == true || json['status']?.toString() == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? SubmittedPengeluaranItem.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SubmittedPengeluaranItem {
  final int id;
  final String namaItem;
  final String kategori;
  final String jumlah;
  final String tanggal;
  final String keterangan;
  final SubmittedPengeluaranUser user;
  final String createdAt;

  SubmittedPengeluaranItem({
    required this.id,
    required this.namaItem,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.user,
    required this.createdAt,
  });

  factory SubmittedPengeluaranItem.fromJson(Map<String, dynamic> json) {
    return SubmittedPengeluaranItem(
      id: json['id'] as int? ?? 0,
      namaItem: json['nama_item']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      jumlah: json['jumlah']?.toString() ?? '0',
      tanggal: json['tanggal']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      user: SubmittedPengeluaranUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? const {},
      ),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class SubmittedPengeluaranUser {
  final int id;
  final String name;

  SubmittedPengeluaranUser({
    required this.id,
    required this.name,
  });

  factory SubmittedPengeluaranUser.fromJson(Map<String, dynamic> json) {
    return SubmittedPengeluaranUser(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
