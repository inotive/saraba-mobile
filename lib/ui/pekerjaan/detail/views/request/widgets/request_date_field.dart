import 'package:flutter/material.dart';

class RequestDateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const RequestDateField({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1F1F1F)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ),
            Container(
              width: 44,
              height: 48,
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFF1F1F1F))),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF5D93E8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
