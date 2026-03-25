abstract class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

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
