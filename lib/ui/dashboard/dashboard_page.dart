import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saraba_mobile/ui/dashboard/absensi_preview_page.dart';
import 'package:saraba_mobile/ui/widgets/attendance_status_card.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFFB7C4D6)),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 16),
              _attendanceCard(true, context),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _projectSection(),
      ],
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo, Biko 👋',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Senior Accountant',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(bool isClockedIn, BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              const Text(
                "Don’t miss your attendance today!",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 6),
                  Text("22 July 2024   02:45:30"),
                ],
              ),
              isClockedIn == true
                  ? Container(
                      margin: EdgeInsetsDirectional.symmetric(vertical: 16.0),
                      child: AttendanceStatusCard(
                        clockInTime: "09:00 WITA",
                        clockOutTime: "17:00 WITA",
                        isClockInDone: true,
                        isClockOutDone: true,
                      ),
                    )
                  : const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          await handleClockIn(context);
                        },
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          "Clock in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 24, color: Colors.white),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Clock out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Proyek Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _projectCard("Proyek A", 0.6),
                  const SizedBox(height: 12),
                  _projectCard("Proyek B", 0.3),
                  const SizedBox(height: 12),
                  _projectCard("Proyek C", 0.2),
                  const SizedBox(height: 12),
                  _projectCard("Proyek D", 0.1),
                  const SizedBox(height: 12),
                  _projectCard("Proyek E", 0.546),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectCard(String title, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text("${(progress * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nilai:", style: TextStyle(color: Colors.black54)),
                    Text("Rp 500.000.000"),
                  ],
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pengeluaran:",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text("Rp 120.000.000"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  // Need refactor later, this is just a quick implementation for demo purpose
  final ImagePicker _picker = ImagePicker();

  Future<void> handleClockIn(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (photo == null) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latitude = position.latitude.toString();
    final longitude = position.longitude.toString();

    final imageFile = File(photo.path);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendancePreviewPage(
          imageFile: imageFile,
          employeeName: "Rahmad Hidayat",
          timeText: "08:00 WITA",
          buttonText: "Clock In",
          retryText: "Foto Ulang",

          onRetake: () {
            Navigator.pop(context);
          },

          onSubmit: () {},
        ),
      ),
    );
  }
}
