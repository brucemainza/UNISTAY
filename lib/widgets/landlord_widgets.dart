part of '../main.dart';

class LandlordHouseCard extends StatelessWidget {
  const LandlordHouseCard({
    super.key,
    required this.house,
    required this.onTap,
  });

  final House house;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: borderGray),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: PropertyHero(house: house, height: 100),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(icon: Icons.home_outlined, text: house.name),
                    const SizedBox(height: 8),
                    InfoRow(
                      icon: Icons.location_on_outlined,
                      text: house.location,
                    ),
                    const SizedBox(height: 8),
                    InfoRow(
                      icon: Icons.event_seat_outlined,
                      text: '${house.availableSpaces} Spaces Avail.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
