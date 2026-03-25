import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';
import 'package:saraba_mobile/ui/dashboard/absensi_preview_page.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_state.dart';
import 'package:saraba_mobile/ui/dashboard/camera_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/project_detail_page.dart';
import 'package:saraba_mobile/ui/widgets/attendance_status_card.dart';
import 'package:saraba_mobile/ui/widgets/project_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
              _attendanceCard(context),
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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profile) {
          return Row(
            children: [
              _buildProfileAvatar(profile),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${profile.displayName} 👋',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profile.displayRole,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileState profile) {
    if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: FileImage(File(profile.avatarPath!)),
      );
    }

    if (profile.remoteAvatar.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(profile.remoteAvatar),
      );
    }

    return const CircleAvatar(
      radius: 24,
      backgroundColor: Color(0xFFF1F3F5),
      child: Icon(Icons.person, color: Color(0xFF9AA0A6), size: 24),
    );
  }

  Widget _attendanceCard(BuildContext context) {
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
              BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  final hasAttendance =
                      state.clockInTime != null || state.clockOutTime != null;

                  return Column(
                    children: [
                      hasAttendance
                          ? Container(
                              margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 16.0,
                              ),
                              child: AttendanceStatusCard(
                                clockInTime: state.clockInTime,
                                clockOutTime: state.clockOutTime,
                                isClockInDone: state.clockInTime != null,
                                isClockOutDone: state.clockOutTime != null,
                              ),
                            )
                          : const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: state.isLoading
                                ? null
                                : () async {
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
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    await handleClockOut(context);
                                  },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              "Clock out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectSection() {
    final List<ProjectModel> projects = [
      ProjectModel(
        id: "1",
        title: "Proyek A",
        progress: 0.6,
        nilai: "Rp 500.000.000",
        pengeluaran: "Rp 120.000.000",
      ),
      ProjectModel(
        id: "2",
        title: "Proyek B",
        progress: 0.3,
        nilai: "Rp 300.000.000",
        pengeluaran: "Rp 120.000.000",
      ),
      ProjectModel(
        id: "3",
        title: "Proyek C",
        progress: 0.23,
        nilai: "Rp 30.000.000",
        pengeluaran: "Rp 20.000.000",
      ),
      ProjectModel(
        id: "4",
        title: "Proyek D",
        progress: 0.7,
        nilai: "Rp 3.040.000",
        pengeluaran: "Rp 50.600.000",
      ),
      ProjectModel(
        id: "5",
        title: "Proyek E",
        progress: 0.546,
        nilai: "Rp 120.000.000",
        pengeluaran: "Rp 432.000.000",
      ),
      ProjectModel(
        id: "6",
        title: "Proyek F",
        progress: 0.986,
        nilai: "Rp 4.430.000",
        pengeluaran: "Rp 54.064.000",
      ),
      ProjectModel(
        id: "7",
        title: "Proyek G",
        progress: 0.123,
        nilai: "Rp 734.000.000",
        pengeluaran: "Rp 853.000.000",
      ),
      ProjectModel(
        id: "8",
        title: "Proyek H",
        progress: 0.856,
        nilai: "Rp 563.000",
        pengeluaran: "Rp 223.000",
      ),
    ];

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
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: projects.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = projects[index];
                  return ProjectCard(
                    project: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailPage(projectModel: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  Future<void> handleClockIn(BuildContext context) async {
    final attendanceBloc = context.read<AttendanceBloc>();
    final now = TimeOfDay.now().format(context);
    final frontCamera = await getFrontCamera();
    if (frontCamera == null) return;

    if (!context.mounted) return;
    final XFile? photo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraPage(camera: frontCamera, title: "Clock In"),
      ),
    );

    if (photo == null) return;

    final imageFile = File(photo.path);

    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: attendanceBloc,
          child: AttendancePreviewPage(
            imageFile: imageFile,
            employeeName: "Rahmad Hidayat",
            timeText: now,
            buttonText: "Clock In",
            isClockIn: true,
            onRetake: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Future<void> handleClockOut(BuildContext context) async {
    final attendanceBloc = context.read<AttendanceBloc>();
    final now = TimeOfDay.now().format(context);

    final frontCamera = await getFrontCamera();
    if (frontCamera == null) return;

    if (!context.mounted) return;
    final XFile? photo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraPage(camera: frontCamera, title: "Clock Out"),
      ),
    );

    if (photo == null) return;

    final imageFile = File(photo.path);

    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: attendanceBloc,
          child: AttendancePreviewPage(
            imageFile: imageFile,
            employeeName: "Rahmad Hidayat",
            timeText: now,
            buttonText: "Clock Out",
            isClockIn: false,
            onRetake: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Future<CameraDescription?> getFrontCamera() async {
    final cameras = await availableCameras();

    try {
      return cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } catch (_) {
      return cameras.isNotEmpty ? cameras.first : null;
    }
  }
}
