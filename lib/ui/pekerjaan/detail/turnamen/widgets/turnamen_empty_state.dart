import 'package:flutter/material.dart';

class TurnamenEmptyState extends StatelessWidget {
  final String message;

  const TurnamenEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
        ),
      ),
    );
  }
}
