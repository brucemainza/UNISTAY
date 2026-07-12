part of '../../main.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.initialFilters});

  final List<String> initialFilters;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late final Set<String> selectedFilters = {...widget.initialFilters};

  void toggleFilter(String label, bool? selected) {
    setState(() {
      if (selected ?? false) {
        selectedFilters.add(label);
      } else {
        selectedFilters.remove(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: orangePrimary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SectionTitle('Price range'),
          const SizedBox(height: 12),
          FilterOption(
            label: 'K500 - K1,000',
            selected: selectedFilters.contains('K500 - K1,000'),
            onChanged: (value) => toggleFilter('K500 - K1,000', value),
          ),
          FilterOption(
            label: 'K1,000 - K1,500',
            selected: selectedFilters.contains('K1,000 - K1,500'),
            onChanged: (value) => toggleFilter('K1,000 - K1,500', value),
          ),
          FilterOption(
            label: 'K1,500+',
            selected: selectedFilters.contains('K1,500+'),
            onChanged: (value) => toggleFilter('K1,500+', value),
          ),
          const SizedBox(height: 22),
          const SectionTitle('Amenities'),
          const SizedBox(height: 12),
          for (final amenity in const [
            'Parking',
            'WiFi',
            'Kitchen',
            'Security',
            'Water 24/7',
          ])
            FilterOption(
              label: amenity,
              selected: selectedFilters.contains(amenity),
              onChanged: (value) => toggleFilter(amenity, value),
            ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedFilters.toList());
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
