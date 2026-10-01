import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/project_detail_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/turnamen/turnamen_detail_page.dart';

/// Membuka detail sesuai jenis item: proyek atau turnamen.
void openProjectDetail(BuildContext context, ProjectModel item) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => item.isTurnamen
          ? TurnamenDetailPage(turnamenId: item.id, turnamenTitle: item.title)
          : ProjectDetailPage(projectId: item.id, projectTitle: item.title),
    ),
  );
}
