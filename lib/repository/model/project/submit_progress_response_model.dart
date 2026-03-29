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
  final String catatan;
  final SubmittedProgressUser user;
  final String createdAt;

  SubmittedProgressLog({
    required this.id,
    required this.judul,
    required this.progressPersen,
    required this.tanggal,
    required this.catatan,
    required this.user,
    required this.createdAt,
  });

  factory SubmittedProgressLog.fromJson(Map<String, dynamic> json) {
    return SubmittedProgressLog(
      id: json['id'] as int? ?? 0,
      judul: json['judul']?.toString() ?? '',
      progressPersen: json['progress_persen'] as int? ?? 0,
      tanggal: json['tanggal']?.toString() ?? '',
      catatan: json['catatan']?.toString() ?? '',
      user: SubmittedProgressUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? const {},
      ),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class SubmittedProgressUser {
  final int id;
  final String name;

  SubmittedProgressUser({
    required this.id,
    required this.name,
  });

  factory SubmittedProgressUser.fromJson(Map<String, dynamic> json) {
    return SubmittedProgressUser(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
