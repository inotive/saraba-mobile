import 'package:flutter/material.dart';

class ProjectFotoView extends StatelessWidget {
  const ProjectFotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Foto proyek belum tersedia',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
