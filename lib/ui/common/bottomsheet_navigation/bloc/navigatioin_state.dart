enum NavigationTab {
  dashboard,
  absensi,
  pekerjaan,
  akun,
}

class NavigationState {
  final NavigationTab selectedTab;

  NavigationState({required this.selectedTab});
}