import 'package:flutter/material.dart';

class DetailSheetBox extends StatelessWidget {
  final String text;

  const DetailSheetBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.45,
          color: Color(0xFF1F1F1F),
        ),
      ),
    );
  }
}
