import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_event.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_state.dart';

class AttendancePreviewPage extends StatelessWidget {
  final File imageFile;
  final String employeeName;
  final String timeText;
  final String buttonText;
  final String retryText;
  final String latitude;
  final String longitude;
  final bool isClockIn;
  final VoidCallback onRetake;

  const AttendancePreviewPage({
    super.key,
    required this.imageFile,
    required this.employeeName,
    required this.timeText,
    required this.buttonText,
    required this.retryText,
    required this.latitude,
    required this.longitude,
    required this.isClockIn,
    required this.onRetake,
  });

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
            isClockIn ? "Clock In Preview" : "Clock Out Preview",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text("Map preview here"),
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
                        imageFile,
                        height: 120,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isClockIn ? "Clock In" : "Clock Out",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: state.isLoading ? null : onRetake,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  retryText,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        if (isClockIn) {
                                          context.read<AttendanceBloc>().add(
                                            ClockInSubmitted(
                                              latitude: latitude,
                                              longitude: longitude,
                                              imagePath: imageFile.path,
                                              deviceInfo: "android",
                                            ),
                                          );
                                        } else {
                                          context.read<AttendanceBloc>().add(
                                            ClockOutSubmitted(
                                              latitude: latitude,
                                              longitude: longitude,
                                              imagePath: imageFile.path,
                                              deviceInfo: "android",
                                            ),
                                          );
                                        }
                                      },
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
                                    : Text(buttonText),
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
