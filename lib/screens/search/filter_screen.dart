part of '../../main.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.initialFilters});

  final List<String> initialFilters;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Set<String> selectedFilters = {...widget.initialFilters};
  RangeValues priceRange = const RangeValues(800, 2000);
  double distance = 3;

  void toggle(String value) {
    setState(() {
      if (!selectedFilters.add(value)) selectedFilters.remove(value);
    });
  }

  Widget chip(String label, {bool selected = false, IconData? icon}) {
    final active = selected || selectedFilters.contains(label);
    return FilterChip(
      selected: active,
      showCheckmark: false,
      avatar: icon == null ? null : Icon(icon, size: 15),
      label: Text(label),
      onSelected: (_) => toggle(label),
      selectedColor: const Color(0xFFFFE0B2),
      backgroundColor: Colors.white,
      side: BorderSide(color: active ? orangePrimary : borderGray),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.83,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: borderGray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 12, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Find your stay near UNZA',
                            style: TextStyle(color: grayText, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  children: [
                    _FilterHeading(
                      title: 'Price per month',
                      value:
                          'ZMW ${priceRange.start.round()} – ${priceRange.end.round()}',
                    ),
                    RangeSlider(
                      values: priceRange,
                      min: 500,
                      max: 3000,
                      divisions: 25,
                      activeColor: orangePrimary,
                      inactiveColor: lightOrange,
                      onChanged: (value) => setState(() => priceRange = value),
                    ),
                    const _SliderLabels(left: 'ZMW 500', right: 'ZMW 3,000+'),
                    const SizedBox(height: 10),
                    _FilterHeading(
                      title: 'Distance to UNZA',
                      value: 'Within ${distance.round()} km',
                    ),
                    Slider(
                      value: distance,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      activeColor: orangePrimary,
                      inactiveColor: lightOrange,
                      onChanged: (value) => setState(() => distance = value),
                    ),
                    const _SliderLabels(left: '0 km', right: '5 km+'),
                    const SizedBox(height: 10),
                    const Text(
                      'Property type',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        chip('Any'),
                        chip('Boarding house'),
                        chip('Flat'),
                        chip('Studio'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bedrooms',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        chip('Any bedrooms'),
                        chip('1'),
                        chip('2'),
                        chip('3'),
                        chip('4+'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Amenities',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        chip('WiFi', icon: Icons.wifi),
                        chip('Water 24/7'),
                        chip('Security'),
                        chip('Power backup'),
                        chip('Furnished'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Gender preference',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        chip('Any gender'),
                        chip('Female only'),
                        chip('Male only'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Text(
                          'Sort by',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Spacer(),
                        Text(
                          'Recommended ⌄',
                          style: TextStyle(color: orangePrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: borderGray)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          selectedFilters.clear();
                          priceRange = const RangeValues(800, 2000);
                          distance = 3;
                        }),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, selectedFilters.toList()),
                        child: const Text('Show 24 results'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterHeading extends StatelessWidget {
  const _FilterHeading({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(value, style: const TextStyle(color: orangePrimary, fontSize: 12)),
      ],
    );
  }
}

class _SliderLabels extends StatelessWidget {
  const _SliderLabels({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: const TextStyle(color: grayText, fontSize: 11)),
        Text(right, style: const TextStyle(color: grayText, fontSize: 11)),
      ],
    );
  }
}
