import 'dart:io';
import 'package:flutter/material.dart';

class AttendancePreviewPage extends StatelessWidget {
  final File imageFile;
  final String employeeName;
  final String timeText;
  final String buttonText;
  final String retryText;
  final VoidCallback onSubmit;
  final VoidCallback onRetake;

  const AttendancePreviewPage({
    super.key,
    required this.imageFile,
    required this.employeeName,
    required this.timeText,
    required this.buttonText,
    required this.retryText,
    required this.onSubmit,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Clock In Preview",
          style: TextStyle(fontWeight: FontWeight.w600),
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
                  const Text(
                    "Clock In",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onRetake,
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
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
