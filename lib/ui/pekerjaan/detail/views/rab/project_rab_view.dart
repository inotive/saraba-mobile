import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/widgets/rab_item_card.dart';

class ProjectRabView extends StatefulWidget {
  final ProjectRabSection rab;

  const ProjectRabView({super.key, required this.rab});

  @override
  State<ProjectRabView> createState() => _ProjectRabViewState();
}

class _ProjectRabViewState extends State<ProjectRabView> {
  final Set<int> _expandedIds = <int>{};

  @override
  Widget build(BuildContext context) {
    final items = widget.rab.items
        .where((item) => item.tipe.trim().toLowerCase() == 'header')
        .toList();

    if (items.isEmpty) {
      return const _EmptyRabState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        final detailItems = _collectVisibleItems(item);
        final isExpanded = _expandedIds.contains(item.id);

        return RabItemCard(
          title: item.uraian,
          totalItem: detailItems.length,
          totalHarga: _buildTotalHarga(item, detailItems),
          isExpanded: isExpanded,
          iconAsset: _buildHeaderIconAsset(detailItems),
          detailRows: detailItems
              .map(
                (detail) => RabDetailRowData(
                  title: detail.uraian,
                  subtitle: _buildSubtitle(detail),
                  category: _buildCategoryLabel(detail.kategori),
                  amount: _formatCurrency(detail.jumlah),
                ),
              )
              .toList(),
          onToggle: () => _toggleExpanded(item.id),
        );
      },
    );
  }

  void _toggleExpanded(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  List<ProjectRabItem> _collectVisibleItems(ProjectRabItem parent) {
    final result = <ProjectRabItem>[];

    void visit(ProjectRabItem item) {
      final isLeafItem = item.tipe.trim().toLowerCase() == 'item';
      final hasMeaningfulName = item.uraian.trim().isNotEmpty;

      if (isLeafItem && hasMeaningfulName) {
        result.add(item);
      }

      for (final child in item.children) {
        visit(child);
      }
    }

    for (final child in parent.children) {
      visit(child);
    }

    return result;
  }

  String _buildTotalHarga(
    ProjectRabItem header,
    List<ProjectRabItem> detailItems,
  ) {
    final headerTotal = double.tryParse(header.jumlah) ?? 0;
    if (headerTotal > 0) {
      return _formatCurrency(header.jumlah);
    }

    final childTotal = detailItems.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.jumlah) ?? 0),
    );
    return _formatCurrency(childTotal.toString());
  }

  String _buildSubtitle(ProjectRabItem item) {
    final volume = _formatNumber(item.volume);
    final satuan = item.satuan.trim();
    final value = '$volume $satuan'.trim();
    return value.isEmpty ? '-' : value;
  }

  String _buildCategoryLabel(String kategori) {
    final normalized = kategori.trim().toLowerCase();
    switch (normalized) {
      case 'material':
        return 'Material';
      case 'operasional':
        return 'Operasional';
      default:
        return kategori.isEmpty
            ? '-'
            : toBeginningOfSentenceCase(kategori) ?? kategori;
    }
  }

  String _buildHeaderIconAsset(List<ProjectRabItem> detailItems) {
    final firstCategory = detailItems.isEmpty
        ? ''
        : detailItems.first.kategori.trim().toLowerCase();

    switch (firstCategory) {
      case 'material':
        return 'assets/icons/ic_pengeluaran_material.png';
      case 'operasional':
        return 'assets/icons/ic_pengeluaran_operasional.png';
      case 'petty_cash':
      case 'petty cash':
        return 'assets/icons/ic_pengeluaran_petty_cash.png';
      default:
        return 'assets/icons/ic_pengeluaran_material.png';
    }
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

String _formatNumber(String rawValue) {
  final parsedValue = double.tryParse(rawValue);
  if (parsedValue == null) {
    return rawValue;
  }

  return NumberFormat.decimalPattern('id_ID').format(parsedValue);
}

class _EmptyRabState extends StatelessWidget {
  const _EmptyRabState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Data material belum tersedia',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
