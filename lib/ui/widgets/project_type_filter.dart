import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project_model.dart';

/// Dropdown filter jenis item (Semua / Proyek / Turnamen), ringkas agar muat sebaris dengan judul.
class ProjectTypeFilter extends StatelessWidget {
  final PekerjaanFilter selected;
  final ValueChanged<PekerjaanFilter> onChanged;

  const ProjectTypeFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PekerjaanFilter>(
          value: selected,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF848484)),
          items: [
            for (final filter in PekerjaanFilter.values)
              DropdownMenuItem<PekerjaanFilter>(
                value: filter,
                child: Text(
                  filter.label,
                  style: const TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
          onChanged: (filter) {
            if (filter != null) {
              onChanged(filter);
            }
          },
        ),
      ),
    );
  }
}
