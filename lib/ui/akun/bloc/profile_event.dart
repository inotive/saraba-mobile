abstract class ProfileEvent {}

class CheckLocalProfileData extends ProfileEvent {}

class FetchProfileData extends ProfileEvent {}

class UpdateProfileSubmitted extends ProfileEvent {
  final String name;
  final String role;
  final String telepon;
  final String alamat;
  final String? avatarPath;

  UpdateProfileSubmitted({
    required this.name,
    required this.role,
    required this.telepon,
    required this.alamat,
    this.avatarPath,
  });
}

class ChangePasswordSubmitted extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}

class ChangePasswordFeedbackCleared extends ProfileEvent {}

class UpdateProfileFeedbackCleared extends ProfileEvent {}
