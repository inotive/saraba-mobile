import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:saraba_mobile/ui/login/bloc/login_event.dart';
import 'package:saraba_mobile/ui/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      final result = await authService.login(
        email: event.email,
        password: event.password,
      );

      if (result != null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure("Login gagal"));
      }
    });
  }
}
