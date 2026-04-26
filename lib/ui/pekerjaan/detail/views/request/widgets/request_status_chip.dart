import 'package:flutter/material.dart';
import '../models/request_status.dart';

class RequestStatusChip extends StatelessWidget {
  final RequestStatus status;

  const RequestStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (status) {
      RequestStatus.pending => (
        'Pending',
        const Color(0xFFF7944D),
        const Color(0xFFFFF4EA),
      ),
      RequestStatus.processed => (
        'Processed',
        const Color(0xFF5D93E8),
        const Color(0xFFEEF5FF),
      ),
      RequestStatus.done => (
        'Done',
        const Color(0xFF2FA44F),
        const Color(0xFFEFFAF2),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}