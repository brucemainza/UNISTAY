part of '../../main.dart';

class LandlordAmenitiesScreen extends StatelessWidget {
  const LandlordAmenitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Amenities'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          FilterOption(label: 'Parking'),
          FilterOption(label: 'WiFi'),
          FilterOption(label: 'Kitchen'),
          FilterOption(label: 'Water 24/7'),
          FilterOption(label: 'Security'),
        ],
      ),
    );
  }
}
