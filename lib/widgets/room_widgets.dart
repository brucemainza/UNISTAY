part of '../main.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    super.key,
    required this.room,
    required this.onBook,
    required this.onEnquire,
    this.imageUrl,
  });

  final Room room;
  final VoidCallback? onBook;
  final VoidCallback onEnquire;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final available = room.available;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                imageUrl ??
                    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=900&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: lightGray,
                  child: const Icon(Icons.bed_outlined, color: grayText, size: 48),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        room.type,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${kwacha(room.rent)}/mo',
                      style: const TextStyle(
                        color: mintGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final feature in room.features)
                      FeatureTag(label: feature),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onEnquire,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: orangePrimary,
                          side: const BorderSide(color: orangePrimary, width: 1.5),
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Enquire',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: available ? onBook : null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return const Color(0xFFBDBDBD);
                            }
                            return orangePrimary;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.white70;
                            }
                            return Colors.white;
                          }),
                          minimumSize:
                              WidgetStateProperty.all(const Size.fromHeight(46)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Text(
                          available ? 'Book now' : 'Booked out',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentRoomCard extends StatelessWidget {
  const PaymentRoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.bed_outlined, size: 42, color: grayText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              room.type,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            kwacha(room.rent),
            style: const TextStyle(
              color: mintGreen,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
