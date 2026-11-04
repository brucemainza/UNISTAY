part of '../../main.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void selectTab(BuildContext context, int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (index == 1) Navigator.pushReplacementNamed(context, Routes.map);
    if (index == 2) Navigator.pushReplacementNamed(context, Routes.saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Account'),
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 3,
        onTabSelected: (index) => selectTab(context, index),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: orangePrimary),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: orangePrimary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: orangePrimary,
                    size: 42,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bruce Mainza',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('UNZA student · Lusaka'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your account',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _AccountMenuRow(
            icon: Icons.home_outlined,
            label: 'My Accommodation',
            subtitle: 'Confirmed rooms and receipts',
            showIconBadge: true,
            onTap: () =>
                Navigator.pushNamed(context, Routes.myAccommodation),
          ),
          _AccountMenuRow(
            icon: Icons.account_circle_outlined,
            label: 'My Profile',
            subtitle: 'Personal details and UNZA student ID',
            onTap: () => Navigator.pushNamed(context, Routes.profile),
          ),
          const SizedBox(height: 8),
          const Text(
            'Preferences & support',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _AccountMenuRow(
            icon: Icons.settings_outlined,
            label: 'Settings',
            subtitle: 'Notifications, privacy and security',
            onTap: () => Navigator.pushNamed(context, Routes.settings),
          ),
          _AccountMenuRow(
            icon: Icons.support_agent_outlined,
            label: 'Customer Care',
            subtitle: 'Get help with your booking',
            onTap: () => Navigator.pushNamed(context, Routes.customerCare),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out of UniStay?'),
        content: const Text(
          'You can log back in anytime. Your saved homes and bookings will still be here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              dialogContext,
              Routes.login,
              (route) => false,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.showIconBadge = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool showIconBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: orangePrimary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: showIconBadge ? const Color(0xFFFFF3E0) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: orangePrimary),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
