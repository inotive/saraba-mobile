import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:saraba_mobile/repository/model/absensi/absensi_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:saraba_mobile/ui/absensi/detail/bloc/absensi_detail_bloc.dart';
import 'package:saraba_mobile/ui/absensi/detail/bloc/absensi_detail_event.dart';
import 'package:saraba_mobile/ui/absensi/detail/bloc/absensi_detail_state.dart';

class AbsensiHistoryDetailPage extends StatefulWidget {
  final String absensiId;
  final String initialStatus;

  const AbsensiHistoryDetailPage({
    super.key,
    required this.absensiId,
    required this.initialStatus,
  });

  @override
  State<AbsensiHistoryDetailPage> createState() =>
      _AbsensiHistoryDetailPageState();
}

class _AbsensiHistoryDetailPageState extends State<AbsensiHistoryDetailPage> {
  final ProfileService _profileService = ProfileService();
  String _selectedTab = 'Check In';
  String _employeeName = 'User';

  @override
  void initState() {
    super.initState();
    _loadEmployeeName();
  }

  Future<void> _loadEmployeeName() async {
    final currentUser = await _profileService.getCurrentUser();

    if (!mounted) {
      return;
    }

    setState(() {
      _employeeName = currentUser?.name.isNotEmpty == true
          ? currentUser!.name
          : 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AbsensiDetailBloc(AbsensiService())
            ..add(FetchAbsensiDetail(widget.absensiId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: BlocBuilder<AbsensiDetailBloc, AbsensiDetailState>(
            builder: (context, state) {
              final status = state.detail?.status ?? widget.initialStatus;
              return Text(
                'Absensi - ${_formatStatus(status)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
        ),
        body: BlocBuilder<AbsensiDetailBloc, AbsensiDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.detail == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.detail == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AbsensiDetailBloc>().add(
                            FetchAbsensiDetail(widget.absensiId),
                          );
                        },
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final detail = state.detail;
            if (detail == null) {
              return const SizedBox.shrink();
            }

            final normalizedStatus = detail.status.toLowerCase();
            final isLeaveStatus =
                normalizedStatus == 'ijin' || normalizedStatus == 'sakit';

            if (isLeaveStatus) {
              return _buildLeaveDetail(detail);
            }

            final hasCheckOut = detail.jamPulang.trim().isNotEmpty;
            final isCheckOutTab = _selectedTab == 'Check Out';
            final displayTime = isCheckOutTab
                ? detail.jamPulang
                : detail.jamMasuk;
            final coordinate = _buildLatLng(detail.latitude, detail.longitude);

            return Column(
              children: [
                _buildTabBar(hasCheckOut),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: 260,
                        child: coordinate == null
                            ? const Center(
                                child: Text(
                                  'Lokasi tidak tersedia',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            : FlutterMap(
                                options: MapOptions(
                                  initialCenter: coordinate,
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
                                        point: coordinate,
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          children: [
                            const Text(
                              'Nama Pegawai',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _employeeName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildAttendanceImage(detail.fotoUrl),
                            const SizedBox(height: 16),
                            Text(
                              _selectedTab,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatLongDate(detail.tanggal)} ${displayTime.isEmpty ? '-' : displayTime} WITA',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildStatusBadge(detail.status),
                            if (detail.keterangan.trim().isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                detail.keterangan,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaveDetail(AbsensiDetailData detail) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/absensi_sakit_image_background.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoBlock('Nama Pegawai', _employeeName),
              const SizedBox(height: 20),
              _buildInfoBlock('Periode', _formatLongDate(detail.tanggal)),
              const SizedBox(height: 20),
              _buildInfoBlock(
                'Keterangan Izin',
                detail.keterangan.trim().isEmpty ? '-' : detail.keterangan,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(bool hasCheckOut) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Check In', enabled: true)),
          Expanded(child: _buildTabButton('Check Out', enabled: hasCheckOut)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, {required bool enabled}) {
    final isSelected = _selectedTab == label;

    return InkWell(
      onTap: enabled
          ? () {
              setState(() {
                _selectedTab = label;
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF3B5BFF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: enabled
                ? (isSelected ? const Color(0xFF1F1F1F) : Colors.grey)
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return Container(
        width: 90,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF9AA0A6),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 120,
        width: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            width: 90,
            height: 120,
            color: const Color(0xFFF1F3F5),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFF9AA0A6),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final normalized = status.toLowerCase();
    final isPositive = normalized == 'hadir' || normalized == 'telat';
    final bgColor = isPositive
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEF9C3);
    final textColor = isPositive
        ? const Color(0xFF15803D)
        : const Color(0xFFA16207);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatStatus(status),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.check_circle, size: 14, color: textColor),
        ],
      ),
    );
  }

  LatLng? _buildLatLng(String latitude, String longitude) {
    final lat = double.tryParse(latitude);
    final lng = double.tryParse(longitude);

    if (lat == null || lng == null) {
      return null;
    }

    return LatLng(lat, lng);
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return '-';
    }

    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatLongDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return rawDate.split('T').first;
    }
  }
}
