class ProjectRequestSubmitResponse {
  final bool success;
  final String message;
  final ProjectRequestSubmitData? data;

  const ProjectRequestSubmitResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProjectRequestSubmitResponse.fromJson(Map<String, dynamic> json) {
    return ProjectRequestSubmitResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: json['data'] is Map<String, dynamic>
          ? ProjectRequestSubmitData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ProjectRequestSubmitData {
  final int id;
  final int proyekId;
  final String proyekName;
  final String tanggalPermintaan;
  final String deskripsi;
  final String status;

  const ProjectRequestSubmitData({
    required this.id,
    required this.proyekId,
    required this.proyekName,
    required this.tanggalPermintaan,
    required this.deskripsi,
    required this.status,
  });

  factory ProjectRequestSubmitData.fromJson(Map<String, dynamic> json) {
    return ProjectRequestSubmitData(
      id: _parseInt(json['id']),
      proyekId: _parseInt(json['proyek_id']),
      proyekName: (json['proyek_name'] ?? '').toString(),
      tanggalPermintaan: (json['tanggal_permintaan'] ?? '').toString(),
      deskripsi: (json['deskripsi'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
