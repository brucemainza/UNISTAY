part of '../../main.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late final Set<String> savedHouseNames = {
    for (final house in houses.take(2)) house.name,
  };

  void selectTab(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.map);
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, Routes.account);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedHouses = houses
        .where((house) => savedHouseNames.contains(house.name))
        .toList();

    return Scaffold(
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 2,
        onTabSelected: selectTab,
      ),
      appBar: AppBar(title: const Text('Saved')),
      body: savedHouses.isEmpty
          ? _SavedEmptyState(
              onBrowse: () =>
                  Navigator.pushReplacementNamed(context, Routes.home),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemCount: savedHouses.length,
              itemBuilder: (context, index) {
                final house = savedHouses[index];
                return _SavedHouseCard(
                  house: house,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.houseDetail,
                    arguments: house,
                  ),
                  onRemove: () => setState(() {
                    savedHouseNames.remove(house.name);
                  }),
                );
              },
            ),
    );
  }
}

class _SavedEmptyState extends StatelessWidget {
  const _SavedEmptyState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline_rounded,
              color: orangePrimary,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No saved homes yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save homes you like and find them here later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: grayText),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBrowse,
              child: const Text('Browse homes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedHouseCard extends StatelessWidget {
  const _SavedHouseCard({
    required this.house,
    required this.onTap,
    required this.onRemove,
  });

  final House house;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    house.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: Color(0xFFFFF3E0)),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: onRemove,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                      ),
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE9003F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Text(
                house.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
