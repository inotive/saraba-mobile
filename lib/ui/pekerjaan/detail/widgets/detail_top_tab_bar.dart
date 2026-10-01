import 'package:flutter/material.dart';

class DetailTopTabBar extends StatelessWidget {
  final List<String> tabs;

  const DetailTopTabBar({
    super.key,
    this.tabs = const ['Overview', 'RAB', 'Progress', 'Pengeluaran', 'Request'],
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: const Color(0xFF1F1F1F),
      unselectedLabelColor: const Color(0xFF8C8C8C),
      indicatorColor: const Color(0xFF2457F5),
      indicatorWeight: 2,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      tabs: [for (final tab in tabs) Tab(text: tab)],
    );
  }
}
