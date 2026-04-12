import 'package:flutter/material.dart';

class DetailTopTabBar extends StatelessWidget {
  const DetailTopTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Color(0xFF1F1F1F),
      unselectedLabelColor: Color(0xFF8C8C8C),
      indicatorColor: Color(0xFF2457F5),
      indicatorWeight: 2,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      tabs: [
        Tab(text: "Overview"),
        Tab(text: "RAB"),
        Tab(text: "Progress"),
        Tab(text: "Pengeluaran"),
        Tab(text: "Request"),
      ],
    );
  }
}
