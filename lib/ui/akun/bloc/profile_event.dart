abstract class ProfileEvent {}

class CheckLocalProfileData extends ProfileEvent {}

class FetchProfileData extends ProfileEvent {}

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
