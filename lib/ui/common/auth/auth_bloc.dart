import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:saraba_mobile/ui/common/auth/auth_event.dart';
import 'package:saraba_mobile/ui/common/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());

      final success = await authService.logout();

      if (success) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated());
      }
    });
  }
}
