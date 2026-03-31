import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  final List<String> _guaranteeFilterOptions = [
    '6 Bulan Terakhir',
    '3 Bulan Terakhir',
    '12 Bulan Terakhir',
  ];

  late final TabController _tabController;
  String _selectedProjectFilter = 'Terbaru';
  String _selectedGuaranteeFilter = '6 Bulan Terakhir';

  final List<_GuaranteeProfitItem> _guaranteeItems = const [
    _GuaranteeProfitItem(
      name: 'Jordyn Donin',
      hargaModal: 'Rp 120.000.000',
      hargaJual: 'Rp10.000.000',
      keuntungan: 'Rp 120.000.000',
    ),
    _GuaranteeProfitItem(
      name: 'Jordyn Donin',
      hargaModal: 'Rp 120.000.000',
      hargaJual: 'Rp10.000.000',
      keuntungan: 'Rp 120.000.000',
    ),
    _GuaranteeProfitItem(
      name: 'Jordyn Donin',
      hargaModal: 'Rp 120.000.000',
      hargaJual: 'Rp10.000.000',
      keuntungan: 'Rp 120.000.000',
    ),
    _GuaranteeProfitItem(
      name: 'Jordyn Donin',
      hargaModal: 'Rp 120.000.000',
      hargaJual: 'Rp10.000.000',
      keuntungan: 'Rp 120.000.000',
    ),
  ];

  final List<_ChartBarItem> _chartItems = const [
    _ChartBarItem(month: 'Jan', heightFactor: 0.26),
    _ChartBarItem(month: 'Feb', heightFactor: 0.38),
    _ChartBarItem(month: 'Mar', heightFactor: 0.56),
    _ChartBarItem(month: 'Apr', heightFactor: 0.26),
    _ChartBarItem(month: 'May', heightFactor: 0.64),
    _ChartBarItem(month: 'Jun', heightFactor: 0.80),
  ];

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
        _GuaranteeChart(items: _chartItems),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.person_outline,
                iconBackground: Color(0xFFF1F1F1),
                iconColor: Color(0xFF8D8D8D),
                title: 'Total Nasabah',
                value: '55',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                icon: Icons.bar_chart,
                iconBackground: Color(0xFFF1F1F1),
                iconColor: Color(0xFF2F7DFF),
                title: 'Total Profit',
                value: 'Rp505.000.000',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._guaranteeItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GuaranteeProfitCard(item: item),
          );
        }),
      ],
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
                      color: item.month == 'Jun'
                          ? const Color(0xFF202124)
                          : const Color(0xFF8B92A5),
                      fontSize: 13,
                      fontWeight: item.month == 'Jun'
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
  final _GuaranteeProfitItem item;

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
                _InfoItem(label: 'Nama', value: item.name),
                const SizedBox(height: 10),
                _InfoItem(label: 'Harga Jual', value: item.hargaJual),
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
                _InfoItem(label: 'Harga Modal', value: item.hargaModal),
                const SizedBox(height: 10),
                _InfoItem(label: 'Keuntungan', value: item.keuntungan),
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

class _GuaranteeProfitItem {
  final String name;
  final String hargaModal;
  final String hargaJual;
  final String keuntungan;

  const _GuaranteeProfitItem({
    required this.name,
    required this.hargaModal,
    required this.hargaJual,
    required this.keuntungan,
  });
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
