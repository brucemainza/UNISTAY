part of '../main.dart';

/// Repository responsible for payment operations through Lenco.
class PaymentRepository {
  PaymentRepository({UniStayApi? api}) : _api = api ?? UniStayApi();

  final UniStayApi _api;

  Future<PaymentSession> initiateMobileMoneyPayment({
    required int amount,
    required String roomType,
    required String phone,
    required String operator,
  }) async {
    return _api.initiateLencoPayment(
      amount: amount,
      roomType: roomType,
      phone: phone,
      operator: operator,
    );
  }

  Future<PaymentSession> verifyPayment(String reference) async {
    return _api.verifyLencoPayment(reference);
  }
}
