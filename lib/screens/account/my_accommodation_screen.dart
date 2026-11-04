part of '../../main.dart';

class MyAccommodationScreen extends StatefulWidget {
  const MyAccommodationScreen({super.key});

  @override
  State<MyAccommodationScreen> createState() => _MyAccommodationScreenState();
}

class _MyAccommodationScreenState extends State<MyAccommodationScreen> {
  int selectedTab = 0;

  void selectTab(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.map);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, Routes.saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'My Accommodation'),
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 3,
        onTabSelected: selectTab,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              _AccommodationTab(
                label: 'Upcoming · 1',
                selected: selectedTab == 0,
                onTap: () => setState(() => selectedTab = 0),
              ),
              const SizedBox(width: 8),
              _AccommodationTab(
                label: 'Past stays',
                selected: selectedTab == 1,
                onTap: () => setState(() => selectedTab = 1),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (selectedTab == 0) ...[
            _UpcomingBookingCard(
              onManage: () =>
                  Navigator.pushNamed(context, Routes.bookingDetail),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.receipt),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                decoration: BoxDecoration(
                  border: Border.all(color: orangePrimary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your receipt is ready',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'K1,450 paid · Airtel Money · 04 Nov 2026',
                            style: TextStyle(color: grayText, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Move-in is on 01 Dec. Message Mr Chanda to agree on your arrival time.',
              style: TextStyle(color: grayText, height: 1.35),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                child: Text(
                  'No past stays yet.',
                  style: TextStyle(color: grayText),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccommodationTab extends StatelessWidget {
  const _AccommodationTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF3E0) : Colors.white,
          border: Border.all(color: selected ? orangePrimary : borderGray),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _UpcomingBookingCard extends StatelessWidget {
  const _UpcomingBookingCard({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
      decoration: BoxDecoration(
        border: Border.all(color: borderGray),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              houses.first.imageUrl,
              height: 148,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text('Confirmed'),
                side: BorderSide(color: orangePrimary),
                backgroundColor: Color(0xFFFFF3E0),
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text('Paid K1,450'),
                side: BorderSide(color: borderGray),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const Text(
            'Mr Chanda BH',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Single self-contained · Kalingalinga\nUS-261201-0842',
            style: TextStyle(color: grayText, height: 1.45),
          ),
          const SizedBox(height: 8),
          const _AccommodationInfoRow(
            label: 'Move-in',
            value: '01 Dec 2026',
          ),
          const _AccommodationInfoRow(
            label: 'Move-out',
            value: '31 Dec 2026',
          ),
          const _AccommodationInfoRow(
            label: 'Rental period',
            value: 'Monthly',
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onManage,
              child: const Text('Manage booking'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccommodationInfoRow extends StatelessWidget {
  const _AccommodationInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: grayText)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
