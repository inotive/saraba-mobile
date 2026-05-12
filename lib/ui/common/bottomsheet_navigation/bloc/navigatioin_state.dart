enum NavigationTab { dashboard, absensi, pekerjaan, approval, akun }

class NavigationState {
  final NavigationTab selectedTab;

  NavigationState({required this.selectedTab});
}
