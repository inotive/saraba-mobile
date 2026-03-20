import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/widgets/attendance_status_card.dart';

class AbsensiPage extends StatelessWidget {
  const AbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerSection(),
        const SizedBox(height: 16),
        _periodeSection(),
        const SizedBox(height: 12),
        _attendanceList(),
      ],
    );
  }
}

Widget _headerSection() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 50, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Absensi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(color: Color(0xFFB7C4D6)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Row(
                  children: const [
                    CircleAvatar(radius: 20),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jadwal Kerja"),
                        Text(
                          "5 Hari Kerja",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AttendanceStatusCard(
                  clockInTime: "09:00 WITA",
                  clockOutTime: "17:00 WITA",
                  isClockInDone: true,
                  isClockOutDone: true,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _periodeSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Periode", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // Handle period selection
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: _cardDecoration(),
            child: Row(
              children: const [
                Expanded(child: Text("Maret 2026")),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _attendanceList() {
  return Expanded(
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: const [
        AttendanceItem(day: "30", status: "Masuk", note: "On Time"),
        AttendanceItem(day: "29", status: "Masuk", note: "On Time"),
        AttendanceItem(day: "28", status: "Ijin", note: "-"),
        AttendanceItem(day: "27", status: "Sakit", note: "-"),
        AttendanceItem(day: "26", status: "Masuk", note: "On Time"),
      ],
    ),
  );
}

class AttendanceItem extends StatelessWidget {
  final String day;
  final String status;
  final String note;

  const AttendanceItem({
    super.key,
    required this.day,
    required this.status,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Tanggal ",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      TextSpan(
                        text: day,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Waktu ",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      TextSpan(
                        text: "08:42:10",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _divider(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Status",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                _statusBadge(status),
              ],
            ),
          ),
          _divider(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keterangan",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(note),
                    if (note == "On Time")
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade300,
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;

    switch (status) {
      case "Masuk":
        bg = Colors.green.shade100;
        text = Colors.green;
        break;
      case "Ijin":
        bg = Colors.orange.shade100;
        text = Colors.orange;
        break;
      default:
        bg = Colors.grey.shade300;
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(color: text, fontSize: 12)),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
