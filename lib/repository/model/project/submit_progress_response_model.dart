class SubmitProgressResponse {
  final bool success;
  final String message;
  final SubmittedProgressLog? data;

  SubmitProgressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubmitProgressResponse.fromJson(Map<String, dynamic> json) {
    return SubmitProgressResponse(
      success:
          json['success'] == true || json['status']?.toString() == 'success',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? SubmittedProgressLog.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SubmittedProgressLog {
  final int id;
  final String judul;
  final int progressPersen;
  final String tanggal;
  final int jumlahTukang;
  final String catatan;
  final SubmittedProgressUser? user;
  final String createdAt;
  final String updatedAt;

  SubmittedProgressLog({
    required this.id,
    required this.judul,
    required this.progressPersen,
    required this.tanggal,
    required this.jumlahTukang,
    required this.catatan,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubmittedProgressLog.fromJson(Map<String, dynamic> json) {
    return SubmittedProgressLog(
      id: _parseInt(json['id']),
      judul: json['judul']?.toString() ?? '',
      progressPersen: _parseInt(json['progress_persen']),
      tanggal: json['tanggal']?.toString() ?? '',
      jumlahTukang: _parseInt(json['jumlah_tukang']),
      catatan: json['catatan']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? SubmittedProgressUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

class SubmittedProgressUser {
  final int id;
  final String name;

  SubmittedProgressUser({required this.id, required this.name});

  factory SubmittedProgressUser.fromJson(Map<String, dynamic> json) {
    return SubmittedProgressUser(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}
