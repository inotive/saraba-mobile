import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:saraba_mobile/repository/services/profile_service.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_event.dart';
import 'package:saraba_mobile/ui/akun/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc(this.profileService) : super(const ProfileState()) {
    on<CheckLocalProfileData>(_onCheckLocalProfileData);
    on<FetchProfileData>(_onFetchProfileData);
    on<UpdateProfileSubmitted>(_onUpdateProfileSubmitted);
    on<UpdateProfileFeedbackCleared>(_onUpdateProfileFeedbackCleared);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<ChangePasswordFeedbackCleared>(_onChangePasswordFeedbackCleared);
  }

  Future<void> _onCheckLocalProfileData(
    CheckLocalProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        clearErrorMessage: true,
      ),
    );

    final localUser = await profileService.getCurrentUser();
    final avatarPath = await profileService.getAvatarPath();

    if (localUser != null) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: false,
          avatarPath: avatarPath,
          fallbackName: localUser.name,
          fallbackRole: localUser.role,
          fallbackEmail: localUser.email,
        ),
      );
      return;
    }

    await _fetchProfileData(emit);
  }

  Future<void> _onFetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        clearErrorMessage: true,
      ),
    );

    await _fetchProfileData(emit);
  }

  Future<void> _fetchProfileData(Emitter<ProfileState> emit) async {
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

  Future<void> _onUpdateProfileSubmitted(
    UpdateProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdatingProfile: true,
        clearUpdateProfileFeedback: true,
      ),
    );

    try {
      await profileService.updateProfile(
        name: event.name,
        role: event.role,
        telepon: event.telepon,
        alamat: event.alamat,
        avatarPath: event.avatarPath,
      );

      final profile = await profileService.getProfile();
      final localUser = await profileService.getCurrentUser();
      final avatarPath = await profileService.getAvatarPath();

      emit(
        state.copyWith(
          isUpdatingProfile: false,
          isError: profile == null,
          errorMessage: profile == null ? 'Gagal memuat profile' : null,
          profile: profile,
          avatarPath: avatarPath,
          fallbackName: localUser?.name,
          fallbackRole: localUser?.role,
          fallbackEmail: localUser?.email,
          updateProfileSuccessMessage: 'Profile berhasil diperbarui',
          updateProfileErrorMessage: null,
        ),
      );
    } on DioException catch (e) {
      final message =
          (e.response?.data is Map<String, dynamic>)
              ? (e.response?.data['message'] as String? ??
                    'Gagal memperbarui profil')
              : 'Gagal memperbarui profil';

      emit(
        state.copyWith(
          isUpdatingProfile: false,
          updateProfileSuccessMessage: null,
          updateProfileErrorMessage: message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isUpdatingProfile: false,
          updateProfileSuccessMessage: null,
          updateProfileErrorMessage: 'Gagal memperbarui profil',
        ),
      );
    }
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

  void _onUpdateProfileFeedbackCleared(
    UpdateProfileFeedbackCleared event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearUpdateProfileFeedback: true));
  }
}
