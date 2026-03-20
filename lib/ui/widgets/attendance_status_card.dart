import 'package:flutter/material.dart';

class AttendanceStatusCard extends StatelessWidget {
  final String? clockInTime;
  final String? clockOutTime;
  final bool isClockInDone;
  final bool isClockOutDone;

  const AttendanceStatusCard({
    super.key,
    this.clockInTime,
    this.clockOutTime,
    this.isClockInDone = false,
    this.isClockOutDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: _statusItem(
              title: "Clock In",
              time: clockInTime ?? "--:--",
              icon: Icons.arrow_upward,
              isDone: isClockInDone,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: _statusItem(
              title: "Clock Out",
              time: clockOutTime ?? "--:--",
              icon: Icons.arrow_downward,
              isDone: isClockOutDone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusItem({
    required String title,
    required String time,
    required IconData icon,
    required bool isDone,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(width: 8),
        if (isDone)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
      ],
    );
  }
}
