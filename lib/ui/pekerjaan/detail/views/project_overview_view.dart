import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';

class ProjectOverviewView extends StatelessWidget {
  final ProjectModel projectModel;

  const ProjectOverviewView({super.key, required this.projectModel});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(projectModel.title));
  }
}
