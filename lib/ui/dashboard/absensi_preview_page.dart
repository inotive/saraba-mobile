import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_event.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_state.dart';

class AttendancePreviewPage extends StatefulWidget {
  final File imageFile;
  final String employeeName;
  final String timeText;
  final String buttonText;
  final bool isClockIn;
  final VoidCallback onRetake;

  const AttendancePreviewPage({
    super.key,
    required this.imageFile,
    required this.employeeName,
    required this.timeText,
    required this.buttonText,
    required this.isClockIn,
    required this.onRetake,
  });

  @override
  State<AttendancePreviewPage> createState() => _AttendancePreviewPageState();
}

class _AttendancePreviewPageState extends State<AttendancePreviewPage> {
  String? latitude;
  String? longitude;
  bool isPreparingLocation = true;
  String? locationError;

  @override
  void initState() {
    super.initState();
    _prepareLocation();
  }

  Future<void> _prepareLocation() async {
    try {
      final position = await _getLocation();

      if (!mounted) return;

      if (position == null) {
        setState(() {
          isPreparingLocation = false;
          locationError = "Lokasi tidak diizinkan atau tidak tersedia";
        });
        return;
      }

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        isPreparingLocation = false;
        locationError = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isPreparingLocation = false;
        locationError = "Gagal mendapatkan lokasi";
      });
    }
  }

  Future<Position?> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
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
          deviceInfo: "android",
        ),
      );
    } else {
      context.read<AttendanceBloc>().add(
        ClockOutSubmitted(
          latitude: latitude!,
          longitude: longitude!,
          imagePath: widget.imageFile.path,
          deviceInfo: "android",
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
          Navigator.pop(context);
        } else if (state.isError && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
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
              height: 220,
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
                          userAgentPackageName: 'com.example.saraba_mobile',
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
                  children: [
                    const Text(
                      "Nama Pegawai",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.employeeName,
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

                    if (isPreparingLocation)
                      const Text(
                        "Menyiapkan lokasi...",
                        style: TextStyle(color: Colors.grey),
                      )
                    else if (locationError != null)
                      Text(
                        locationError!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        "Lokasi siap",
                        style: TextStyle(color: Colors.green),
                      ),

                    const SizedBox(height: 8),

                    BlocBuilder<AttendanceBloc, AttendanceState>(
                      builder: (context, state) {
                        return state.isError && state.message != null
                            ? Text(
                                state.message!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    const Spacer(),

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
                                    : widget.onRetake,
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
                                    : Text(widget.buttonText),
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
