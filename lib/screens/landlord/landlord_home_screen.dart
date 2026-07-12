part of '../../main.dart';

class LandlordHomeScreen extends StatefulWidget {
  const LandlordHomeScreen({super.key});

  @override
  State<LandlordHomeScreen> createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePrimary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          ),
        ),
        title: const Text(
          'my UniStay',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, Routes.landlordProfile);
              }
              if (value == 'care') {
                Navigator.pushNamed(context, Routes.customerCare);
              }
              if (value == 'logout') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'care', child: Text('Customer Care')),
              PopupMenuItem(value: 'logout', child: Text('Log out')),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: orangePrimary,
        shape: const CircleBorder(
          side: BorderSide(color: orangePrimary, width: 2),
        ),
        onPressed: () =>
            Navigator.pushNamed(context, Routes.landlordHouseRegSuccess),
        child: const Icon(Icons.add, size: 36),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 64,
        color: orangePrimary,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.white),
            SizedBox(width: 52),
            Icon(Icons.notifications_outlined, color: Colors.white),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: houses.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final house = houses[index];
          return LandlordHouseCard(
            house: house,
            onTap: () => Navigator.pushNamed(
              context,
              Routes.landlordHouseDetail,
              arguments: house,
            ),
          );
        },
      ),
    );
  }
}
