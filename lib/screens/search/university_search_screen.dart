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
      appBar: const UniAppBar(title: 'Choose university'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search university or campus',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Find accommodation close to your lectures.', style: TextStyle(color: grayText)),
          const SizedBox(height: 16),
          const Text('Universities & campuses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (final university in filtered)
            Card(
              color: university == filtered.first ? const Color(0xFFFFE0B2) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: orangePrimary)),
              child: ListTile(
                leading: const Icon(Icons.school_outlined, color: orangePrimary),
                title: Text('${university.initials}  ${university.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('Great East Road · Lusaka'),
                trailing: Icon(university == filtered.first ? Icons.check_circle_outline : Icons.chevron_right, color: orangePrimary),
                onTap: () => Navigator.pop(context, university),
              ),
            ),
        ],
      ),
    );
  }
}
