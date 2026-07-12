part of '../../main.dart';

class MyAccommodationScreen extends StatelessWidget {
  const MyAccommodationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'My Accommodation'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          BookingCard(
            status: 'Confirmed',
            house: 'Mr Chanda BH',
            room: 'Single Room, Selfcontained',
            total: 'K1,450',
          ),
          BookingCard(
            status: 'Pending visit',
            house: 'Sunrise Flats',
            room: 'Studio Room',
            total: 'K2,000',
          ),
        ],
      ),
    );
  }
}
