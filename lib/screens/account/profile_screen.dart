part of '../../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'My Profile'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: CircleAvatar(radius: 38, backgroundColor: Color(0xFFFFF3E0), child: Icon(Icons.person_outline, color: orangePrimary, size: 44))),
          const SizedBox(height: 10),
          const Center(child: Chip(label: Text('Verified student'))),
          for (final field in const [('Full name', 'Bruce Mainza'), ('Email address', 'student@unza.zm'), ('Phone number', '+260 97 123 4567'), ('University', 'UNZA')]) ...[
            Text(field.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(decoration: InputDecoration(hintText: field.$2)),
            const SizedBox(height: 14),
          ],
          ElevatedButton(onPressed: () => showSnack(context, 'Profile saved'), child: const Text('Save changes')),
        ],
      ),
    );
  }
}
