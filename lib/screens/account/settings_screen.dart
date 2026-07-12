part of '../../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('Booking notifications'),
          ),
          SwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Marketing updates'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy and security'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
