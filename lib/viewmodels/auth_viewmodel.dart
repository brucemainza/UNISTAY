part of '../main.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthRepository? repository})
      : _repository = repository ?? const AuthRepository();

  final AuthRepository _repository;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  String _selectedRole = 'Student';
  String _errorMessage = '';
  bool _loading = false;

  String get selectedRole => _selectedRole;
  String get errorMessage => _errorMessage;
  bool get loading => _loading;

  void selectRole(String role) {
    if (_selectedRole == role) return;
    _selectedRole = role;
    _notify();
  }

  void clearError() {
    if (_errorMessage.isEmpty) return;
    _errorMessage = '';
    _notify();
  }

  Future<({bool success, String? route})> login({
    required String phone,
    required String password,
  }) async {
    _loading = true;
    _errorMessage = '';
    _notify();

    final result = await _repository.login(
      phone: phone,
      password: password,
      role: _selectedRole,
    );

    _loading = false;
    _errorMessage = result.success ? '' : result.message;
    _notify();

    if (!result.success) {
      return (success: false, route: null);
    }
    final route = _selectedRole == 'Landlord' ? Routes.landlordHome : Routes.home;
    return (success: true, route: route);
  }

  Future<bool> validateRegistration({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _loading = true;
    _errorMessage = '';
    _notify();

    final result = await _repository.validateRegistration(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    _loading = false;
    _errorMessage = result.success ? '' : result.message;
    _notify();

    return result.success;
  }
}
