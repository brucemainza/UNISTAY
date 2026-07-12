part of '../main.dart';

class PaymentSession {
  const PaymentSession({
    required this.reference,
    required this.status,
    required this.message,
    required this.amount,
    required this.currency,
    this.lencoReference,
  });

  factory PaymentSession.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return PaymentSession(
      reference: (data['reference'] ?? '').toString(),
      status: (data['status'] ?? 'pending').toString(),
      message: (json['message'] ?? data['message'] ?? '').toString(),
      amount: (data['amount'] ?? '').toString(),
      currency: (data['currency'] ?? 'ZMW').toString(),
      lencoReference: data['lencoReference']?.toString(),
    );
  }

  final String reference;
  final String status;
  final String message;
  final String amount;
  final String currency;
  final String? lencoReference;
}
