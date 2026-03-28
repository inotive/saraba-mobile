import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';
import 'package:saraba_mobile/ui/dashboard/absensi_preview_page.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_bloc.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_event.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_state.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_state.dart';
import 'package:saraba_mobile/ui/dashboard/camera_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_state.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/project_detail_page.dart';
import 'package:saraba_mobile/ui/widgets/attendance_status_card.dart';
import 'package:saraba_mobile/ui/widgets/project_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _refreshDashboard() async {
    context.read<ProfileBloc>().add(FetchProfileData());
    context.read<AbsensiBloc>().add(FetchTodayAbsensi());
    context.read<PekerjaanBloc>().add(FetchProyeks(page: 1));
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFFB7C4D6)),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 0,
                  child: Image.asset(
                    'assets/images/dashboard_background_image.png',
                    width: 130,
                  ),
                ),
                Column(
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _attendanceCard(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _projectSection(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 24),
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
          child: BlocBuilder<AbsensiBloc, AbsensiState>(
            builder: (context, absensiState) {
              final todayData = absensiState.todayData;
              final absensi = todayData?.absensi;

              return Column(
                children: [
                  const Text(
                    "Don’t miss your attendance today!",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        todayData?.today.isNotEmpty == true
                            ? todayData!.today
                            : '-',
                      ),
                    ],
                  ),
                  if (absensiState.isLoadingToday)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    )
                  else if (todayData != null)
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                        vertical: 16.0,
                      ),
                      child: AttendanceStatusCard(
                        clockInTime: absensi?.jamMasuk.isNotEmpty == true
                            ? absensi!.jamMasuk
                            : null,
                        clockOutTime: absensi?.jamKeluar.isNotEmpty == true
                            ? absensi!.jamKeluar
                            : null,
                        isClockInDone: todayData.isClockedIn,
                        isClockOutDone: todayData.isClockedOut,
                      ),
                    )
                  else
                    const SizedBox(height: 16),
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
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Clock in",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: state.isLoading
                                    ? null
                                    : () async {
                                        await handleClockOut(context);
                                      },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _projectSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: BlocBuilder<PekerjaanBloc, PekerjaanState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.errorMessage != null && state.projects.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Proyek Anda",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            );
          }

          if (state.projects.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Proyek Anda",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: const Text(
                    'Belum ada proyek untuk ditampilkan',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            );
          }

          final projects = state.projects.take(5).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Proyek Anda",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
            ],
          );
        },
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
    final absensiBloc = context.read<AbsensiBloc>();
    final now = TimeOfDay.now().format(context);
    final frontCamera = await getFrontCamera();
    if (frontCamera == null) return;

    await _runAttendanceFlow(
      context: context,
      attendanceBloc: attendanceBloc,
      absensiBloc: absensiBloc,
      frontCamera: frontCamera,
      title: "Clock In",
      timeText: now,
      buttonText: "Clock In",
      isClockIn: true,
    );
  }

  Future<void> handleClockOut(BuildContext context) async {
    final attendanceBloc = context.read<AttendanceBloc>();
    final absensiBloc = context.read<AbsensiBloc>();
    final now = TimeOfDay.now().format(context);

    final frontCamera = await getFrontCamera();
    if (frontCamera == null) return;

    await _runAttendanceFlow(
      context: context,
      attendanceBloc: attendanceBloc,
      absensiBloc: absensiBloc,
      frontCamera: frontCamera,
      title: "Clock Out",
      timeText: now,
      buttonText: "Clock Out",
      isClockIn: false,
    );
  }

  Future<void> _runAttendanceFlow({
    required BuildContext context,
    required AttendanceBloc attendanceBloc,
    required AbsensiBloc absensiBloc,
    required CameraDescription frontCamera,
    required String title,
    required String timeText,
    required String buttonText,
    required bool isClockIn,
  }) async {
    while (context.mounted) {
      final XFile? photo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CameraPage(camera: frontCamera, title: title),
        ),
      );

      if (photo == null || !context.mounted) {
        return;
      }

      final result = await Navigator.push<AttendancePreviewResult>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: attendanceBloc,
            child: AttendancePreviewPage(
              imageFile: File(photo.path),
              timeText: timeText,
              buttonText: buttonText,
              isClockIn: isClockIn,
            ),
          ),
        ),
      );

      if (!context.mounted || result == null) {
        return;
      }

      if (result.action == AttendancePreviewAction.retake) {
        continue;
      }

      final isSuccess = result.action == AttendancePreviewAction.success;

      if (isSuccess) {
        absensiBloc.add(FetchTodayAbsensi());
      }

      StatusBanner.show(
        context,
        title: isSuccess
            ? (isClockIn ? 'Clock In Berhasil' : 'Clock Out Berhasil')
            : (isClockIn ? 'Clock In Gagal' : 'Clock Out Gagal'),
        message: result.message ??
            (isSuccess
                ? 'Absensi berhasil dikirim'
                : 'Absensi gagal dikirim'),
        type: isSuccess ? StatusBannerType.success : StatusBannerType.error,
      );
      return;
    }
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
