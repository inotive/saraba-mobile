import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:saraba_mobile/core/utils/device_info_helper.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:saraba_mobile/repository/services/location_service.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_event.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_state.dart';

enum AttendancePreviewAction { success, failure, retake }

class AttendancePreviewResult {
  final AttendancePreviewAction action;
  final String? message;

  const AttendancePreviewResult({required this.action, this.message});
}

class AttendancePreviewPage extends StatefulWidget {
  final File imageFile;
  final String timeText;
  final String buttonText;
  final bool isClockIn;

  const AttendancePreviewPage({
    super.key,
    required this.imageFile,
    required this.timeText,
    required this.buttonText,
    required this.isClockIn,
  });

  @override
  State<AttendancePreviewPage> createState() => _AttendancePreviewPageState();
}

class _AttendancePreviewPageState extends State<AttendancePreviewPage> {
  final LocationService _locationService = LocationService();
  final ProfileService _profileService = ProfileService();

  String? latitude;
  String? longitude;
  String? deviceInfo;
  String employeeName = 'User';
  bool isPreparingLocation = true;
  String? locationError;

  @override
  void initState() {
    super.initState();
    _prepareAttendanceData();
    _loadEmployeeName();
  }

  Future<void> _prepareAttendanceData() async {
    try {
      final positionFuture = _locationService.getCurrentLocation();
      final deviceInfoFuture = DeviceInfoHelper.getDeviceInfo();

      final position = await positionFuture;
      final resolvedDeviceInfo = await deviceInfoFuture;

      if (!mounted) return;

      if (position == null) {
        setState(() {
          isPreparingLocation = false;
          deviceInfo = resolvedDeviceInfo;
          locationError = "Lokasi tidak diizinkan atau tidak tersedia";
        });
        return;
      }

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        deviceInfo = resolvedDeviceInfo;
        isPreparingLocation = false;
        locationError = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isPreparingLocation = false;
        deviceInfo = "Unknown Device";
        locationError = "Gagal mendapatkan lokasi";
      });
    }
  }

  Future<void> _loadEmployeeName() async {
    final currentUser = await _profileService.getCurrentUser();

    if (!mounted) {
      return;
    }

    setState(() {
      employeeName = currentUser?.name.isNotEmpty == true
          ? currentUser!.name
          : 'User';
    });
  }

  void _submit(BuildContext context) {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum siap. Coba lagi sebentar.")),
      );
      return;
    }

    if (widget.isClockIn) {
      context.read<AttendanceBloc>().add(
        ClockInSubmitted(
          latitude: latitude!,
          longitude: longitude!,
          imagePath: widget.imageFile.path,
          deviceInfo: deviceInfo ?? "Unknown Device",
        ),
      );
    } else {
      context.read<AttendanceBloc>().add(
        ClockOutSubmitted(
          latitude: latitude!,
          longitude: longitude!,
          imagePath: widget.imageFile.path,
          deviceInfo: deviceInfo ?? "Unknown Device",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.isSuccess != current.isSuccess ||
          previous.isError != current.isError ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(
            context,
            AttendancePreviewResult(
              action: AttendancePreviewAction.success,
              message: state.message,
            ),
          );
        } else if (state.isError && state.message != null) {
          Navigator.pop(
            context,
            AttendancePreviewResult(
              action: AttendancePreviewAction.failure,
              message: state.message,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            widget.isClockIn ? "Clock In Preview" : "Clock Out Preview",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: isPreparingLocation
                  ? const Center(child: CircularProgressIndicator())
                  : locationError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          locationError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          double.parse(latitude!),
                          double.parse(longitude!),
                        ),
                        initialZoom: 17,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.saraba.inotive',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                double.parse(latitude!),
                                double.parse(longitude!),
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Nama Pegawai",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employeeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        widget.imageFile,
                        height: 120,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isClockIn ? "Clock In" : "Clock Out",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.timeText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    BlocBuilder<AttendanceBloc, AttendanceState>(
                      builder: (context, state) {
                        final isSubmitDisabled =
                            state.isLoading || isPreparingLocation;

                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        Navigator.pop(
                                          context,
                                          const AttendancePreviewResult(
                                            action:
                                                AttendancePreviewAction.retake,
                                          ),
                                        );
                                      },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Foto Ulang",
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isSubmitDisabled
                                    ? null
                                    : () => _submit(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: state.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        widget.buttonText,
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
