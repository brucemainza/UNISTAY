part of '../../main.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void selectTab(BuildContext context, int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (index == 1) Navigator.pushReplacementNamed(context, Routes.map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 2,
        onTabSelected: (index) => selectTab(context, index),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          18,
          MediaQuery.paddingOf(context).top + 18,
          18,
          24,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: orangePrimary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: orangePrimary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 46,
                    color: orangePrimary,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bruce Mainza',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Student account',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          AccountStatChip(label: '1 booking'),
                          AccountStatChip(label: 'Lusaka'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          AccountMenuItem(
            icon: Icons.home_outlined,
            label: 'My Accommodation',
            subtitle: 'Confirmed rooms and receipts',
            onTap: () => Navigator.pushNamed(context, Routes.myAccommodation),
          ),
          AccountMenuItem(
            icon: Icons.account_circle_outlined,
            label: 'My Profile',
            subtitle: 'Personal details and contacts',
            onTap: () => Navigator.pushNamed(context, Routes.profile),
          ),
          AccountMenuItem(
            icon: Icons.support_agent,
            label: 'Customer Care',
            subtitle: 'Get help with bookings',
            onTap: () => Navigator.pushNamed(context, Routes.customerCare),
          ),
          AccountMenuItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            subtitle: 'Notifications and preferences',
            onTap: () => Navigator.pushNamed(context, Routes.settings),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: orangePrimary,
              side: const BorderSide(color: orangePrimary),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
