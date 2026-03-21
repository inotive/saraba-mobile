import 'package:flutter/material.dart';

class TambahPengeluaranPage extends StatelessWidget {
  const TambahPengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const _TambahPengeluaranHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel("Nama Pekerjaan"),
                    const SizedBox(height: 8),
                    const _SearchField(
                      hintText: "Ketik Disini",
                      suffixIcon: Icons.search,
                    ),
                    const SizedBox(height: 20),

                    const _FieldLabel("Masukkan Tanggal"),
                    const SizedBox(height: 8),
                    const _DateField(value: "12 Maret 2026"),
                    const SizedBox(height: 20),

                    const _FieldLabel("Riwayat Pengeluaran"),
                    const SizedBox(height: 8),
                    const _MultilineSearchField(hintText: "Ketik Disini"),
                    const SizedBox(height: 20),

                    const _FieldLabel("Detail Nota"),
                    const SizedBox(height: 8),
                    const _MultilineSearchField(hintText: "Ketik Disini"),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Upload Bukti Nota",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          SizedBox(height: 14),
                          _UploadBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7944D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Submit Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TambahPengeluaranHeader extends StatelessWidget {
  const _TambahPengeluaranHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          const Expanded(
            child: Text(
              "Tambah Pengeluaran",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hintText;
  final IconData suffixIcon;

  const _SearchField({required this.hintText, required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: Icon(suffixIcon, color: const Color(0xFF9CA3AF)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String value;

  const _DateField({required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: value,
        hintStyle: const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFF9CA3AF),
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _MultilineSearchField extends StatelessWidget {
  final String hintText;

  const _MultilineSearchField({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 42),
          child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D93E8)),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF5D93E8),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_outlined, color: Color(0xFF2563EB), size: 28),
          SizedBox(height: 8),
          Text(
            "Upload",
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
