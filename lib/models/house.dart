part of '../main.dart';

class House {
  const House({
    required this.name,
    required this.location,
    required this.university,
    required this.price,
    required this.walkTime,
    required this.driveDistance,
    required this.rating,
    required this.availableSpaces,
    required this.accent,
    required this.amenities,
    required this.imageUrls,
    this.paymentMethods = const [],
    this.nearbyUniversities = const [],
  });

  final String name;
  final String location;
  final String university;
  final int price;
  final String walkTime;
  final String driveDistance;
  final double rating;
  final int availableSpaces;
  final Color accent;
  final List<String> amenities;
  final List<String> imageUrls;
  final List<String> paymentMethods;
  final List<({String name, String distance})> nearbyUniversities;

  String get imageUrl => imageUrls.first;
}
