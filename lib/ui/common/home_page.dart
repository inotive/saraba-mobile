import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/absensi/absensi_page.dart';
import 'package:saraba_mobile/ui/akun/akun_page.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigatioin_state.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_bloc.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_event.dart';
import 'package:saraba_mobile/ui/dashboard/dashboard_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/pekerjaan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildPage(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.dashboard:
        return DashboardPage();
      case NavigationTab.absensi:
        return AbsensiPage();
      case NavigationTab.pekerjaan:
        return PekerjaanPage();
      case NavigationTab.akun:
        return AkunPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: _buildPage(state.selectedTab),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: state.selectedTab.index,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  context.read<NavigationBloc>().add(
                    NavigateToPage(NavigationTab.values[index]),
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: "Dashboard",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle),
                    label: "Absensi",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work),
                    label: "Pekerjaan",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: "Akun",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
