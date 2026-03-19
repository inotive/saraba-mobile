import 'package:bloc/bloc.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigatioin_state.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(selectedTab: NavigationTab.dashboard)) {
    on<NavigateToPage>((event, emit) => emit(NavigationState(selectedTab: event.tab)));
  }
}