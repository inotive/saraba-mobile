import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/core/utils/role_access_helper.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/absensi_service.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saraba_mobile/ui/absensi/absensi_page.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_bloc.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/pages/akun_page.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigatioin_state.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_bloc.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_event.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_bloc.dart';
import 'package:saraba_mobile/ui/absensi/bloc/absensi_event.dart';
import 'package:saraba_mobile/ui/dashboard/bloc/attendance_bloc.dart';
import 'package:saraba_mobile/ui/dashboard/dashboard_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/pekerjaan_page.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_bloc.dart';
import 'package:saraba_mobile/ui/pekerjaan/bloc/pekerjaan_event.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';

class HomePage extends StatefulWidget {
  final String? successBannerTitle;
  final String? successBannerMessage;

  const HomePage({
    super.key,
    this.successBannerTitle,
    this.successBannerMessage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _selectedNavColor = Color(0xFF2A4FA2);

  Widget _buildNavIcon(String assetPath, {required bool isSelected}) {
    return Image.asset(
      assetPath,
      width: 18,
      height: 18,
      color: isSelected ? _selectedNavColor : Colors.grey,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.successBannerTitle != null &&
        widget.successBannerMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        StatusBanner.show(
          context,
          title: widget.successBannerTitle!,
          message: widget.successBannerMessage!,
          type: StatusBannerType.success,
        );
      });
    }
  }

  Widget _buildPage(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.dashboard:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AttendanceBloc(AbsensiService())),
            BlocProvider(
              create: (_) => AbsensiBloc(AbsensiService())..add(FetchTodayAbsensi()),
            ),
            BlocProvider(
              create: (_) =>
                  ProfileBloc(ProfileService())..add(FetchProfileData()),
            ),
            BlocProvider(
              create: (_) =>
                  PekerjaanBloc(PekerjaanService())..add(FetchProyeks()),
            ),
          ],
          child: const DashboardPage(),
        );
      case NavigationTab.absensi:
        return BlocProvider(
          create: (_) =>
              ProfileBloc(ProfileService())..add(CheckLocalProfileData()),
          child: const AbsensiPage(),
        );
      case NavigationTab.pekerjaan:
        return BlocProvider(
          create: (_) => PekerjaanBloc(PekerjaanService())..add(FetchProyeks()),
          child: const PekerjaanPage(),
        );
      case NavigationTab.akun:
        return BlocProvider(
          create: (_) =>
              ProfileBloc(ProfileService())..add(CheckLocalProfileData()),
          child: const AkunPage(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<User>('userBox').listenable(
              keys: const ['current_user'],
            ),
            builder: (context, _, child) {
              final currentUser = Hive.box<User>('userBox').get('current_user');
              final visibleTabs = _buildVisibleTabs(currentUser?.role ?? '');
              final selectedTab = visibleTabs.contains(state.selectedTab)
                  ? state.selectedTab
                  : NavigationTab.dashboard;

              if (selectedTab != state.selectedTab) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) {
                    return;
                  }
                  context.read<NavigationBloc>().add(
                    NavigateToPage(selectedTab),
                  );
                });
              }

              return Scaffold(
                body: _buildPage(selectedTab),
                bottomNavigationBar: Container(
                  decoration: const BoxDecoration(
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
                    type: BottomNavigationBarType.fixed,
                    currentIndex: visibleTabs.indexOf(selectedTab),
                    selectedItemColor: _selectedNavColor,
                    unselectedItemColor: Colors.grey,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedLabelStyle: const TextStyle(fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    onTap: (index) {
                      context.read<NavigationBloc>().add(
                        NavigateToPage(visibleTabs[index]),
                      );
                    },
                    items: visibleTabs
                        .map(
                          (tab) => BottomNavigationBarItem(
                            icon: _buildNavIcon(
                              _buildNavAsset(tab),
                              isSelected: selectedTab == tab,
                            ),
                            label: _buildNavLabel(tab),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<NavigationTab> _buildVisibleTabs(String role) {
    if (hasFullMenuAccess(role)) {
      return const [
        NavigationTab.dashboard,
        NavigationTab.absensi,
        NavigationTab.pekerjaan,
        NavigationTab.akun,
      ];
    }

    return const [
      NavigationTab.dashboard,
      NavigationTab.absensi,
      NavigationTab.akun,
    ];
  }

  String _buildNavAsset(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.dashboard:
        return 'assets/icons/ic_dashboard_menu.png';
      case NavigationTab.absensi:
        return 'assets/icons/ic_absensi_menu.png';
      case NavigationTab.pekerjaan:
        return 'assets/icons/ic_pekerjaan_menu.png';
      case NavigationTab.akun:
        return 'assets/icons/ic_akun_menu.png';
    }
  }

  String _buildNavLabel(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.dashboard:
        return 'Dashboard';
      case NavigationTab.absensi:
        return 'Absensi';
      case NavigationTab.pekerjaan:
        return 'Pekerjaan';
      case NavigationTab.akun:
        return 'Akun';
    }
  }
}
