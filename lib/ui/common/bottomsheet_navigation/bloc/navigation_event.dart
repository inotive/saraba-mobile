import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigatioin_state.dart';

abstract class NavigationEvent {}

class NavigateToPage extends NavigationEvent {
  final NavigationTab tab;

  NavigateToPage(this.tab);
}