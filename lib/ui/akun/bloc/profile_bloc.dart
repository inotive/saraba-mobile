import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc(this.profileService) : super(const ProfileState()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<ChangePasswordFeedbackCleared>(_onChangePasswordFeedbackCleared);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        clearErrorMessage: true,
      ),
    );

    final profile = await profileService.getProfile();
    final localUser = await profileService.getCurrentUser();
    final avatarPath = await profileService.getAvatarPath();

    emit(
      state.copyWith(
        isLoading: false,
        isError: profile == null,
        errorMessage: profile == null ? 'Gagal memuat profile' : null,
        profile: profile,
        avatarPath: avatarPath,
        fallbackName: localUser?.name,
        fallbackRole: localUser?.role,
        fallbackEmail: localUser?.email,
      ),
    );
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isChangingPassword: true,
        clearChangePasswordFeedback: true,
      ),
    );

    final result = await profileService.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      newPasswordConfirmation: event.newPasswordConfirmation,
    );

    emit(
      state.copyWith(
        isChangingPassword: false,
        changePasswordSuccessMessage: result?.success == true
            ? result!.message
            : null,
        changePasswordErrorMessage: result?.success == true
            ? null
            : result?.message ?? 'Gagal mengubah password',
      ),
    );
  }

  void _onChangePasswordFeedbackCleared(
    ChangePasswordFeedbackCleared event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearChangePasswordFeedback: true));
  }
}
