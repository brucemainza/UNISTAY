part of '../main.dart';

class UniStayApi {
  UniStayApi({
    http.Client? client,
    this.baseUrl = const String.fromEnvironment(
      'UNISTAY_API_BASE_URL',
      defaultValue: 'http://10.0.2.2:4000/api',
    ),
  }) : client = client ?? http.Client();

  final http.Client client;
  final String baseUrl;

  Map<String, String> get _headers => const {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer dev-student-token',
  };

  Future<PaymentSession> initiateLencoPayment({
    required int amount,
    required String roomType,
    required String phone,
    required String operator,
  }) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/payments/lenco/mobile-money'),
          headers: _headers,
          body: jsonEncode({
            'amount': amount,
            'currency': 'ZMW',
            'roomType': roomType,
            'phone': phone,
            'operator': operator,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PaymentException(
        (payload['message'] ?? 'Payment failed').toString(),
      );
    }
    return PaymentSession.fromJson(payload);
  }

  Future<PaymentSession> verifyLencoPayment(String reference) async {
    final response = await client
        .get(Uri.parse('$baseUrl/payments/lenco/$reference'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PaymentException(
        (payload['message'] ?? 'Verification failed').toString(),
      );
    }
    return PaymentSession.fromJson(payload);
  }
}

class PaymentException implements Exception {
  const PaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
