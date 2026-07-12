part of '../main.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({PaymentRepository? repository})
      : _repository = repository ?? PaymentRepository();

  final PaymentRepository _repository;
  bool _disposed = false;

  DateTime _moveInDate = DateTime.now().add(const Duration(days: 7));
  String _paymentMethod = 'mobile';
  String _operator = 'airtel';
  String _phone = '';
  bool _processing = false;
  String? _error;
  PaymentSession? _session;
  int _retryCount = 0;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  DateTime get moveInDate => _moveInDate;
  String get paymentMethod => _paymentMethod;
  String get operator => _operator;
  String get phone => _phone;
  bool get processing => _processing;
  String? get error => _error;
  PaymentSession? get session => _session;

  void setMoveInDate(DateTime date) {
    if (_moveInDate == date) return;
    _moveInDate = date;
    _notify();
  }

  void setPaymentMethod(String method) {
    if (_paymentMethod == method) return;
    _paymentMethod = method;
    _error = null;
    _notify();
  }

  void setOperator(String operator) {
    if (_operator == operator) return;
    _operator = operator;
    _notify();
  }

  void setPhone(String phone) {
    _phone = phone;
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    _notify();
  }

  Future<bool> pay({required int amount, required String roomType}) async {
    if (_paymentMethod == 'card') {
      return _simulateCardPayment();
    }

    _processing = true;
    _error = null;
    _notify();

    try {
      final created = await _repository.initiateMobileMoneyPayment(
        amount: amount,
        roomType: roomType,
        phone: _phone,
        operator: _operator,
      );
      _session = created;
      _processing = false;
      _notify();
      return created.status == 'successful';
    } on Object catch (e) {
      _processing = false;
      _error = 'Could not start payment: $e';
      _notify();
      return false;
    }
  }

  Future<bool> verifyPayment() async {
    final currentSession = _session;
    if (currentSession == null) return false;

    _processing = true;
    _error = null;
    _notify();

    try {
      final verified = await _repository.verifyPayment(currentSession.reference);
      _session = verified;
      _processing = false;
      _notify();
      return verified.status == 'successful';
    } on Object catch (e) {
      _processing = false;
      _error = 'Could not verify payment: $e';
      _notify();
      return false;
    }
  }

  Future<bool> retryPayment({required int amount, required String roomType}) async {
    if (_retryCount >= 3) {
      _error = 'Max retries reached. Please try again later.';
      _notify();
      return false;
    }
    _retryCount++;
    return pay(amount: amount, roomType: roomType);
  }

  Future<bool> _simulateCardPayment() async {
    _processing = true;
    _error = null;
    _notify();

    await Future.delayed(const Duration(seconds: 2));

    _processing = false;
    _notify();
    return true;
  }
}
