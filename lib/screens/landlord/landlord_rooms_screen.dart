part of '../../main.dart';

class LandlordRoomsScreen extends StatelessWidget {
  const LandlordRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Rooms'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rooms.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ListTile(
            leading: const Icon(
              Icons.meeting_room_outlined,
              color: orangePrimary,
            ),
            title: Text(room.type),
            subtitle: Text(room.available ? 'Available' : 'Booked'),
            trailing: Text(
              '${kwacha(room.rent)}/m',
              style: const TextStyle(
                color: mintGreen,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        },
      ),
    );
  }
}
