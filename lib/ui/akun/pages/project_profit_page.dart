import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saraba_mobile/repository/model/project_profit/guarantee_profit_response_model.dart';
import 'package:saraba_mobile/repository/model/project_profit/project_profit_response_model.dart';
import 'package:saraba_mobile/ui/akun/bloc/project_profit/project_profit_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/project_profit/project_profit_state.dart';

class ProjectProfitPage extends StatefulWidget {
  const ProjectProfitPage({super.key});

  @override
  State<ProjectProfitPage> createState() => _ProjectProfitPageState();
}

class _ProjectProfitPageState extends State<ProjectProfitPage>
    with SingleTickerProviderStateMixin {
  final List<String> _projectFilterOptions = [
    'Terbaru',
    'Minggu Ini',
    'Bulan Ini',
  ];
  final List<String> _guaranteeFilterOptions = ['Terbaru', '6 Bulan Terakhir'];

  late final TabController _tabController;
  String _selectedProjectFilter = 'Terbaru';
  String _selectedGuaranteeFilter = 'Terbaru';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Keuntungan Proyek',
          style: TextStyle(
            color: Color(0xFF202124),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF8F8F8),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF202124),
              unselectedLabelColor: const Color(0xFF7B8090),
              indicatorColor: const Color(0xFF2F7DFF),
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Keuntungan Proyek'),
                Tab(text: 'Keuntungan Jaminan'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE7E7E7)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildProjectTab(), _buildGuaranteeTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTab() {
    return BlocBuilder<ProjectProfitBloc, ProjectProfitState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
          children: [
            _FilterDropdown(
              value: _selectedProjectFilter,
              items: _projectFilterOptions,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedProjectFilter = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (state.isLoading && state.summary == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF7B8090)),
                ),
              )
            else ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _SummaryCard(
                      icon: Icons.receipt_long,
                      iconBackground: const Color(0xFFE9EBEE),
                      iconColor: const Color(0xFF70757E),
                      title: 'Total Proyek',
                      value: '${state.summary?.totalProyek ?? 0}',
                    ),
                    const SizedBox(width: 8),
                    _SummaryCard(
                      icon: Icons.attach_money,
                      iconBackground: const Color(0xFFFCEFD8),
                      iconColor: const Color(0xFFD49B21),
                      title: 'Total Nilai Proyek',
                      value: _formatCurrency(
                        state.summary?.totalNilaiProyek ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SummaryCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconBackground: const Color(0xFFFDE8E8),
                      iconColor: const Color(0xFFE25555),
                      title: 'Total Pengeluaran',
                      value: _formatCurrency(
                        state.summary?.totalPengeluaran ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SummaryCard(
                      icon: Icons.trending_up,
                      iconBackground: const Color(0xFFE4F7EA),
                      iconColor: const Color(0xFF21A366),
                      title: 'Total Profit',
                      value: _formatCurrency(state.summary?.totalProfit ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (state.isLoading && state.items.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(),
                ),
              if (state.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Belum ada data keuntungan proyek',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF7B8090)),
                  ),
                )
              else
                ...state.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ProjectProfitCard(item: item),
                  );
                }),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGuaranteeTab() {
    return BlocBuilder<ProjectProfitBloc, ProjectProfitState>(
      builder: (context, state) {
        final chartItems = _buildGuaranteeChartItems(
          state.guaranteeItems,
          monthCount: _selectedGuaranteeFilter == '6 Bulan Terakhir' ? 6 : 3,
        );
        final totalNilaiJaminan = state.guaranteeItems.fold<double>(
          0,
          (sum, item) => sum + item.nilaiJaminan,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
          children: [
            _FilterDropdown(
              value: _selectedGuaranteeFilter,
              items: _guaranteeFilterOptions,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedGuaranteeFilter = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (state.isGuaranteeLoading && state.guaranteeItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.guaranteeErrorMessage != null &&
                state.guaranteeItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  state.guaranteeErrorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF7B8090)),
                ),
              )
            else ...[
              _GuaranteeChart(items: chartItems),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.receipt_long,
                      iconBackground: const Color(0xFFF1F1F1),
                      iconColor: const Color(0xFF8D8D8D),
                      title: 'Total Jaminan',
                      value: '${state.guaranteeItems.length}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.bar_chart,
                      iconBackground: const Color(0xFFF1F1F1),
                      iconColor: const Color(0xFF2F7DFF),
                      title: 'Total Nilai Jaminan',
                      value: _formatCurrency(totalNilaiJaminan),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.isGuaranteeLoading && state.guaranteeItems.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(),
                ),
              if (state.guaranteeItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Belum ada data jaminan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF7B8090)),
                  ),
                )
              else
                ...state.guaranteeItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GuaranteeProfitCard(item: item),
                  );
                }),
            ],
          ],
        );
      },
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF848484)),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF202124),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8B92A5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF202124),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectProfitCard extends StatelessWidget {
  final ProjectProfitItem item;

  const _ProjectProfitCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.namaProyek,
            style: const TextStyle(
              color: Color(0xFF202124),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _LabelValueBlock(
                  label: 'Nilai:',
                  value: '',
                  alignStart: true,
                ),
              ),
              Expanded(
                child: _LabelValueBlock(
                  label: 'Pengeluaran:',
                  value: '',
                  alignStart: true,
                  showDivider: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatCurrency(item.nilaiProyek),
                  style: const TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 14),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Text(
                    _formatCurrency(item.nilaiPengeluaran),
                    style: const TextStyle(
                      color: Color(0xFF202124),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFCFF7EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23C18F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  'Keuntungan : ${_formatCurrency(item.keuntungan)}',
                  style: const TextStyle(
                    color: Color(0xFF56777A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuaranteeChart extends StatelessWidget {
  final List<_ChartBarItem> items;

  const _GuaranteeChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final currentMonthLabel = DateFormat('MMM', 'id_ID').format(DateTime.now());

    return Container(
      height: 336,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        FractionallySizedBox(
                          heightFactor: item.heightFactor,
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8F45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.month,
                    style: TextStyle(
                      color: item.month == currentMonthLabel
                          ? const Color(0xFF202124)
                          : const Color(0xFF8B92A5),
                      fontSize: 13,
                      fontWeight: item.month == currentMonthLabel
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GuaranteeProfitCard extends StatelessWidget {
  final GuaranteeProfitItem item;

  const _GuaranteeProfitCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(label: 'Nasabah', value: item.namaNasabah),
                const SizedBox(height: 10),
                _InfoItem(label: 'Jenis', value: item.jenisJaminan),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 70,
            color: const Color(0xFFE7E7E7),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(
                  label: 'Nilai Jaminan',
                  value: _formatCurrency(item.nilaiJaminan),
                ),
                const SizedBox(height: 10),
                _InfoItem(label: 'Status', value: item.statusText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8B92A5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF202124),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LabelValueBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool alignStart;
  final bool showDivider;

  const _LabelValueBlock({
    required this.label,
    required this.value,
    required this.alignStart,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showDivider ? const EdgeInsets.only(left: 14) : EdgeInsets.zero,
      decoration: showDivider
          ? const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
            )
          : null,
      child: Column(
        crossAxisAlignment: alignStart
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8B92A5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF202124),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}

class _ChartBarItem {
  final String month;
  final double heightFactor;

  const _ChartBarItem({required this.month, required this.heightFactor});
}

List<_ChartBarItem> _buildGuaranteeChartItems(
  List<GuaranteeProfitItem> items, {
  int monthCount = 12,
}) {
  final monthlyTotals = <String, double>{};
  for (final item in items) {
    final date = DateTime.tryParse(item.tglTerbit);
    if (date == null) {
      continue;
    }
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    monthlyTotals.update(
      key,
      (value) => value + item.nilaiJaminan,
      ifAbsent: () => item.nilaiJaminan,
    );
  }

  final maxValue = monthlyTotals.values.fold<double>(
    0,
    (max, value) => value > max ? value : max,
  );

  final availableMonths = monthlyTotals.keys.toList()..sort();
  final monthsToShow = availableMonths.length <= monthCount
      ? availableMonths
      : availableMonths.sublist(availableMonths.length - monthCount);

  return monthsToShow.map((key) {
    final parts = key.split('-');
    final date = DateTime(
      int.tryParse(parts[0]) ?? DateTime.now().year,
      int.tryParse(parts[1]) ?? 1,
    );
    final total = monthlyTotals[key] ?? 0;
    final factor = maxValue <= 0 ? 0.08 : (total / maxValue).clamp(0.08, 1.0);

    return _ChartBarItem(
      month: DateFormat('MMM', 'id_ID').format(date),
      heightFactor: factor,
    );
  }).toList();
}
