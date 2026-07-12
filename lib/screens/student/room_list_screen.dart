part of '../../main.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key, required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniAppBar(title: house.name),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: rooms.length,
        separatorBuilder: (_, _) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return RoomItem(
            room: room,
            imageUrl: house.imageUrl,
            onBook: room.available
                ? () => Navigator.pushNamed(
                    context,
                    Routes.payment,
                    arguments: room,
                  )
                : null,
            onEnquire: () => showSnack(context, 'Enquiry sent to landlord'),
          );
        },
      ),
    );
  }
}
