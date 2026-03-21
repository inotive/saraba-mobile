import 'package:flutter/material.dart';

class RabSegmentedTab extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const RabSegmentedTab({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTab('Pekerjaan'),
        const SizedBox(width: 6),
        _buildTab('Material'),
      ],
    );
  }

  Widget _buildTab(String value) {
    final isSelected = selectedValue == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D93E8) : const Color(0xFFDCE9FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF5D93E8),
          ),
        ),
      ),
    );
  }
}
