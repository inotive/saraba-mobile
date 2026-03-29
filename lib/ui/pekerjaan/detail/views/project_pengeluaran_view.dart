import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/bloc/project_detail_event.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/tambah_pengeluaran_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/pengeluaran_item_card.dart';

class ProjectPengeluaranView extends StatelessWidget {
  final ProjectPengeluaranSection pengeluaran;

  const ProjectPengeluaranView({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    final groupedData = <String, List<ProjectPengeluaranItem>>{};
    for (final item in pengeluaran.items) {
      groupedData.putIfAbsent(item.tanggal, () => []).add(item);
    }
    final dates = groupedData.keys.toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: pengeluaran.items.isEmpty
              ? const _EmptyPengeluaranState()
              : ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final items = groupedData[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatLongDate(date),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PengeluaranItemCard(
                              title: item.namaItem,
                              category: item.kategori,
                              userName: item.user.name,
                              tanggal: _formatShortDate(item.tanggal),
                              pengeluaran: _formatCurrency(item.jumlah),
                              description: item.keterangan,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                final projectId = context
                    .read<ProjectDetailBloc>()
                    .state
                    .detail
                    ?.overview
                    .id
                    .toString();

                if (projectId == null || projectId.isEmpty) {
                  return;
                }

                Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TambahPengeluaranPage(projectId: projectId),
                  ),
                ).then((message) {
                  if (!context.mounted || message == null || message.isEmpty) {
                    return;
                  }

                  context.read<ProjectDetailBloc>().add(
                    FetchProjectDetail(projectId),
                  );

                  StatusBanner.show(
                    context,
                    title: 'Pengeluaran Berhasil',
                    message: message,
                    type: StatusBannerType.success,
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7944D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah Pengeluaran",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatCurrency(String rawValue) {
  final parsedValue = double.tryParse(rawValue) ?? 0;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(parsedValue);
}

String _formatLongDate(String rawDate) {
  try {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

String _formatShortDate(String rawDate) {
  try {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

class _EmptyPengeluaranState extends StatelessWidget {
  const _EmptyPengeluaranState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Belum ada pengeluaran untuk ditampilkan',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
