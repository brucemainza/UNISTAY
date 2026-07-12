part of '../../main.dart';

class UniversitySearchScreen extends StatefulWidget {
  const UniversitySearchScreen({super.key});

  @override
  State<UniversitySearchScreen> createState() => _UniversitySearchScreenState();
}

class _UniversitySearchScreenState extends State<UniversitySearchScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = controller.text.toLowerCase();
    final filtered = universityOptions
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.initials.toLowerCase().contains(query),
        )
        .toList();
    return Scaffold(
      appBar: const UniAppBar(title: 'University Search'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search university',
            ),
          ),
          const SizedBox(height: 16),
          for (final university in filtered)
            ListTile(
              leading: const Icon(Icons.school_outlined, color: orangePrimary),
              title: Text(
                '${university.initials}  ${university.name}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text('Show nearby boarding houses'),
              onTap: () {
                Navigator.pop(context, university);
              },
            ),
        ],
      ),
    );
  }
}
