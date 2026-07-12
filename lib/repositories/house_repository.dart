part of '../main.dart';

/// Repository responsible for house/accommodation data.
///
/// Currently returns the in-memory mock list. When the backend exposes a
/// houses endpoint, swap the implementation to call the API.
class HouseRepository {
  const HouseRepository();

  Future<List<House>> fetchHouses() async {
    // Simulate network latency for realistic loading states.
    await Future.delayed(const Duration(milliseconds: 300));
    return houses;
  }

  List<House> filterHouses(
    List<House> source, {
    UniversityOption? university,
    Set<String> filters = const {},
    String query = '',
  }) {
    return source.where((house) {
      final matchesUniversity = university == null ||
          house.university.toLowerCase() == university.name.toLowerCase();
      final matchesQuery = query.isEmpty ||
          house.name.toLowerCase().contains(query.toLowerCase()) ||
          house.location.toLowerCase().contains(query.toLowerCase());
      final matchesFilters = filters.every((filter) {
        final lower = filter.toLowerCase();
        return house.amenities.any(
              (amenity) => amenity.toLowerCase().contains(lower),
            ) ||
            _priceMatches(house.price, lower);
      });
      return matchesUniversity && matchesQuery && matchesFilters;
    }).toList();
  }

  bool _priceMatches(int price, String filter) {
    if (filter.contains('k500') && filter.contains('k1,000')) {
      return price >= 500 && price <= 1000;
    }
    if (filter.contains('k1,000') && filter.contains('k1,500')) {
      return price >= 1000 && price <= 1500;
    }
    if (filter.contains('k1,500+')) {
      return price > 1500;
    }
    return false;
  }

  List<House> similarHouses(House target) {
    return houses.where((h) => h.name != target.name).toList();
  }
}
