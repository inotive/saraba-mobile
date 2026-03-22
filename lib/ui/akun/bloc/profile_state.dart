import 'package:saraba_mobile/repository/model/profile_response_model.dart';

class ProfileState {
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final ProfileResponse? profile;
  final String? avatarPath;
  final String? fallbackName;
  final String? fallbackRole;
  final String? fallbackEmail;
  final bool isChangingPassword;
  final String? changePasswordSuccessMessage;
  final String? changePasswordErrorMessage;

  const ProfileState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.profile,
    this.avatarPath,
    this.fallbackName,
    this.fallbackRole,
    this.fallbackEmail,
    this.isChangingPassword = false,
    this.changePasswordSuccessMessage,
    this.changePasswordErrorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool clearErrorMessage = false,
    ProfileResponse? profile,
    String? avatarPath,
    String? fallbackName,
    String? fallbackRole,
    String? fallbackEmail,
    bool? isChangingPassword,
    String? changePasswordSuccessMessage,
    String? changePasswordErrorMessage,
    bool clearChangePasswordFeedback = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      profile: profile ?? this.profile,
      avatarPath: avatarPath ?? this.avatarPath,
      fallbackName: fallbackName ?? this.fallbackName,
      fallbackRole: fallbackRole ?? this.fallbackRole,
      fallbackEmail: fallbackEmail ?? this.fallbackEmail,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      changePasswordSuccessMessage: clearChangePasswordFeedback
          ? null
          : changePasswordSuccessMessage ?? this.changePasswordSuccessMessage,
      changePasswordErrorMessage: clearChangePasswordFeedback
          ? null
          : changePasswordErrorMessage ?? this.changePasswordErrorMessage,
    );
  }

  String get displayName {
    final karyawanName = profile?.data.karyawan?.nama ?? '';
    if (karyawanName.isNotEmpty) {
      return karyawanName;
    }

    final userName = profile?.data.user.name ?? '';
    if (userName.isNotEmpty) {
      return userName;
    }

    return fallbackName ?? 'User';
  }

  String get displayRole {
    final jabatan = profile?.data.karyawan?.jabatan ?? '';
    if (jabatan.isNotEmpty) {
      return jabatan;
    }

    final userRole = profile?.data.user.role ?? '';
    if (userRole.isNotEmpty) {
      return userRole;
    }

    return fallbackRole ?? 'Admin';
  }

  String get remoteAvatar {
    return profile?.data.user.avatar ?? '';
  }
}
