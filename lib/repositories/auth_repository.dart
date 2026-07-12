part of '../main.dart';

/// Repository responsible for authentication operations.
///
/// Currently backed by mock local validation and the [UniStayApi] for real
/// authentication once the backend is wired up.
class AuthRepository {
  const AuthRepository();

  /// Validates credentials locally and returns a hard-coded success for the
  /// demo. In production this should call a [UniStayApi] login endpoint.
  Future<({bool success, String message, String? role})> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    if (phone.isEmpty || password.isEmpty) {
      return (success: false, message: 'Please enter the fields here', role: null);
    }
    if (phone.length != 10) {
      return (
        success: false,
        message: 'Phone number must be 10 digits',
        role: null,
      );
    }

    // Demo path: accept any 10-digit phone + non-empty password.
    await Future.delayed(const Duration(milliseconds: 400));
    return (success: true, message: '', role: role);
  }

  /// Validates registration fields locally.
  Future<({bool success, String message})> validateRegistration({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return (success: false, message: 'Please enter the fields here');
    }
    if (phone.length != 10) {
      return (success: false, message: 'Phone number must be 10 digits');
    }
    if (password != confirmPassword) {
      return (success: false, message: 'Passwords do not match');
    }
    return (success: true, message: '');
  }
}
