import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project/turnamen_detail_response_model.dart';

/// Detail pemain (sama dengan dialog "Detail Pemain" di web), hanya baca.
void showPemainDetailSheet(BuildContext context, TurnamenPemain pemain) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PemainDetailSheet(pemain: pemain),
  );
}

class _PemainDetailSheet extends StatelessWidget {
  final TurnamenPemain pemain;

  const _PemainDetailSheet({required this.pemain});

  @override
  Widget build(BuildContext context) {
    final isAktif = pemain.status.toLowerCase() == 'aktif';

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Detail Pemain",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle("Informasi Pribadi"),
            _Field(label: "Nama Lengkap", value: pemain.namaPemain, bold: true),
            _Field(label: "Jenis Kelamin", value: pemain.jenisKelamin),
            _Field(label: "Nomor HP", value: pemain.nomorHp),
            _Field(label: "Email", value: pemain.email),
            _StatusField(label: "Status", value: pemain.status, isAktif: isAktif),
            const SizedBox(height: 8),
            const _SectionTitle("Informasi Bank & Alamat"),
            _Field(label: "Nama Bank", value: pemain.namaBank),
            _Field(label: "No Rekening", value: pemain.noRekening),
            _Field(label: "Provinsi", value: pemain.provinsi),
            _Field(label: "Kabupaten/Kota", value: pemain.kabupaten),
            _Field(label: "Kecamatan", value: pemain.kecamatan),
            _Field(label: "Kelurahan/Desa", value: pemain.kelurahan),
            _Field(label: "Alamat Lengkap", value: pemain.alamatLengkap),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2A4A),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _Field({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
          ),
          const SizedBox(height: 3),
          Text(
            value.trim().isEmpty ? '-' : value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusField extends StatelessWidget {
  final String label;
  final String value;
  final bool isAktif;

  const _StatusField({
    required this.label,
    required this.value,
    required this.isAktif,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAktif ? const Color(0xFF15803D) : const Color(0xFFB91C1C);
    final background = isAktif
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEE2E2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value.isEmpty
                  ? '-'
                  : value[0].toUpperCase() + value.substring(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
