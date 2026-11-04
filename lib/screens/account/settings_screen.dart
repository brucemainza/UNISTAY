part of '../../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Booking updates'), subtitle: const Text('Confirmations, payments and reminders')),
          SwitchListTile(value: true, onChanged: (_) {}, title: const Text('New messages'), subtitle: const Text('Replies from landlords')),
          SwitchListTile(value: false, onChanged: (_) {}, title: const Text('Offers & recommendations'), subtitle: const Text('Homes and price changes near campus')),
          const Divider(height: 28),
          const Text('Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          for (final item in const [('Privacy & security', 'Password, account access and data'), ('Language', 'English'), ('Payment preferences', 'Airtel Money · +260 97 123 4567')])
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: orangePrimary)),
              child: ListTile(title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(item.$2), trailing: const Icon(Icons.chevron_right)),
            ),
          const SizedBox(height: 14),
          const Center(child: Text('UniStay · App version 1.0.0', style: TextStyle(color: grayText))),
        ],
      ),
    );
  }
}
