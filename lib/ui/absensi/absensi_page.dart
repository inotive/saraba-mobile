import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_bloc.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_event.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_state.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';
import 'package:saraba_mobile/ui/absensi/detail/absensi_history_detail_page.dart';
import 'package:saraba_mobile/ui/absensi/detail/absensi_history_detail_page.dart';
import 'package:saraba_mobile/ui/widgets/attendance_status_card.dart';
import 'package:shimmer/shimmer.dart';

class AbsensiPage extends StatelessWidget {
  const AbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AbsensiBloc(AbsensiService())
        ..add(FetchTodayAbsensi())
        ..add(LoadAbsensiPage()),
      child: _AbsensiView(),
    );
  }
}

class _AbsensiView extends StatefulWidget {
  const _AbsensiView();

  @override
  State<_AbsensiView> createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<_AbsensiView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      context.read<AbsensiBloc>().add(LoadMoreAbsensiHistory());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsensiBloc, AbsensiState>(
      builder: (context, state) {
        return Column(
          children: [
            _headerSection(state),
            const SizedBox(height: 16),
            _periodeSection(context, state),
            const SizedBox(height: 12),
            _attendanceList(state),
          ],
        );
      },
    );
  }

  Widget _headerSection(AbsensiState state) {
    final todayData = state.todayData;
    final absensi = todayData?.absensi;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Absensi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(color: Color(0xFFB7C4D6)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Row(
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, profile) {
                          return _buildProfileAvatar(profile);
                        },
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Jadwal Kerja"),
                          Text(
                            "5 Hari Kerja",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AttendanceStatusCard(
                    clockInTime: absensi?.jamMasuk.isNotEmpty == true
                        ? absensi!.jamMasuk
                        : null,
                    clockOutTime: absensi?.jamKeluar.isNotEmpty == true
                        ? absensi!.jamKeluar
                        : null,
                    isClockInDone: todayData?.isClockedIn ?? false,
                    isClockOutDone: todayData?.isClockedOut ?? false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileState profile) {
    if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: FileImage(File(profile.avatarPath!)),
      );
    }

    if (profile.remoteAvatar.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(profile.remoteAvatar),
      );
    }

    return const CircleAvatar(
      radius: 20,
      backgroundColor: Color(0xFFF1F3F5),
      child: Icon(Icons.person, color: Color(0xFF9AA0A6), size: 20),
    );
  }

  Widget _periodeSection(BuildContext context, AbsensiState state) {
    final monthText = _monthLabel(state.selectedMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Periode", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final selected = await _showMonthPicker(
                context,
                state.selectedMonth,
              );

              if (selected == null || !context.mounted) return;

              context.read<AbsensiBloc>().add(ChangeAbsensiMonth(selected));
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Expanded(child: Text(monthText)),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _showMonthPicker(
    BuildContext context,
    DateTime current,
  ) async {
    final now = DateTime.now();
    final months = List.generate(24, (index) {
      return DateTime(now.year, now.month - index, 1);
    });

    return showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Pilih Periode",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: months.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final month = months[index];
                      final isSelected =
                          month.year == current.year &&
                          month.month == current.month;

                      return ListTile(
                        title: Text(_monthLabel(month)),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () => Navigator.pop(context, month),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _attendanceList(AbsensiState state) {
    if (state.isLoading && state.historyList.isEmpty) {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 6,
          itemBuilder: (_, _) => const AttendanceItemSkeleton(),
        ),
      );
    }

    if (state.isError && state.historyList.isEmpty) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AbsensiBloc>().add(LoadAbsensiPage());
          },
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage ?? "Gagal memuat absensi"),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AbsensiBloc>().add(LoadAbsensiPage());
                        },
                        child: const Text("Coba Lagi"),
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

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<AbsensiBloc>().add(LoadAbsensiPage());
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.historyList.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.historyList.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final item = state.historyList[index];

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: AttendanceItem(
                absensiId: item.id,
                day: _extractDay(item.tanggal),
                status: item.status,
                note: item.keterangan,
                time: item.jamMasuk.isNotEmpty ? item.jamMasuk : "-",
              ),
            );
          },
        ),
      ),
    );
  }

  String _extractDay(String tanggal) {
    if (tanggal.isEmpty) return "-";

    final normalizedDate = tanggal.split('T').first.split(' ').first;
    final parts = normalizedDate.split('-');
    if (parts.length == 3) {
      return parts[2];
    }

    return normalizedDate;
  }

  String _monthLabel(DateTime date) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${months[date.month]} ${date.year}';
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
}

class AttendanceItem extends StatelessWidget {
  final String absensiId;
  final String day;
  final String status;
  final String note;
  final String time;

  const AttendanceItem({
    super.key,
    required this.absensiId,
    required this.day,
    required this.status,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final displayNote = note.trim().isEmpty ? '-' : note;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AbsensiHistoryDetailPage(
              absensiId: absensiId,
              initialStatus: status,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Tanggal ",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        TextSpan(
                          text: day,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Waktu ",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        TextSpan(
                          text: time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _divider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  _statusBadge(status),
                ],
              ),
            ),
            _divider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Keterangan",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayNote,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      if (displayNote == "On Time")
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.check_circle,
                            size: 12,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade300,
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    final normalizedStatus = status.toLowerCase();

    switch (normalizedStatus) {
      case "hadir":
      case "telat":
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF15803D);
        break;
      case "ijin":
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFFA16207);
        break;
      default:
        bg = Colors.grey.shade300;
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(color: text, fontSize: 12)),
    );
  }
}

class AttendanceItemSkeleton extends StatelessWidget {
  const AttendanceItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _block(width: 80, height: 40),
            const SizedBox(width: 8),
            _block(width: 1, height: 40),
            const SizedBox(width: 8),
            _block(width: 60, height: 20),
            const SizedBox(width: 8),
            _block(width: 1, height: 40),
            const SizedBox(width: 8),
            _block(width: 80, height: 20),
          ],
        ),
      ),
    );
  }

  Widget _block({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
