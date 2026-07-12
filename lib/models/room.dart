part of '../main.dart';

class Room {
  const Room({
    required this.type,
    required this.rent,
    required this.deposit,
    required this.available,
    this.features = const [],
  });

  final String type;
  final int rent;
  final int deposit;
  final bool available;
  final List<String> features;
}
