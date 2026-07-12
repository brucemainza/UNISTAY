part of '../../main.dart';

class LandlordHouseDetailScreen extends StatelessWidget {
  const LandlordHouseDetailScreen({super.key, required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniAppBar(title: house.name),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          PropertyHero(house: house, height: 180),
          const SizedBox(height: 18),
          Text(
            house.location,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '${house.availableSpaces} Spaces Available',
            style: const TextStyle(
              color: mintGreen,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, Routes.landlordRooms),
            icon: const Icon(Icons.meeting_room_outlined),
            label: const Text('Rooms'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, Routes.landlordAmenities),
            icon: const Icon(Icons.checklist_outlined),
            label: const Text('Amenities'),
          ),
        ],
      ),
    );
  }
}
