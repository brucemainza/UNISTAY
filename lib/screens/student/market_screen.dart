part of '../../main.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});
  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _search = TextEditingController();
  String _query = '', _category = 'All';
  int _promo = 0;
  final List<_Vendor> _mine = [];

  static const categories = [
    'All',
    'Fridge & Stove Repair',
    'Laptop Repair',
    'Phone Repair',
    'Hardware & Locks',
    'Electrician',
    'Plumber',
    'Cleaning',
    'Laundry',
    'Hair Salon',
    'Barber Shop',
    'Braiding',
    'Makeup Artist',
    'Photographer',
    'Fashion & Tailoring',
    'Clothes & Shoes',
    'Phones & Laptops',
    'Accessories',
    'Vegetables & Fruit',
    'Food & Cakes',
    'Printing & Typing',
    'Tutoring',
    'Delivery & Transport',
    'Events & DJ',
  ];

  static const vendors = [
    _Vendor(
      'Mutale Fix-It',
      'Fridge & Stove Repair',
      'Same-day fixes for fridges, stoves and heaters',
      'Fridge not cooling? Stove element dead? I diagnose on the spot and quote before I touch anything. Call-outs to hostels and flats across Lusaka.',
      '0977 000 101',
      'Matero, Lusaka (travels)',
      4.6,
      73,
      Icons.kitchen_rounded,
      Color(0xFFB5651D),
      [
        _Item('Call-out and diagnosis', 80),
        _Item('Fridge re-gas', 350),
        _Item('Stove element replacement', 180),
      ],
    ),
    _Vendor(
      'Kafue Laptop Hub',
      'Laptop Repair',
      'Laptop repairs, upgrades and refurbished machines',
      'Screen, keyboard and battery repairs, Windows reinstalls and SSD upgrades. Refurbished Dell, HP and Lenovo laptops tested and cleaned.',
      '0977 000 102',
      'Cairo Road, Lusaka',
      4.7,
      66,
      Icons.laptop_mac_rounded,
      Color(0xFF2E6F95),
      [
        _Item('Windows reinstall', 150),
        _Item('SSD upgrade (256GB)', 650),
        _Item('Keyboard replacement', 300),
        _Item('Refurbished HP EliteBook', 4200),
      ],
    ),
    _Vendor(
      'Tech Corner UNZA',
      'Phone Repair',
      'Phones, chargers, screen protectors and repairs',
      'New and used phones with a 30-day warranty. Screen replacement and battery swaps done in under two hours.',
      '0977 000 104',
      'Great East Road Campus',
      4.4,
      156,
      Icons.phone_android_rounded,
      Color(0xFF5A5A9D),
      [
        _Item('Screen replacement', 450),
        _Item('Battery swap', 200),
        _Item('Fast charger + cable', 120),
      ],
    ),
    _Vendor(
      "Mwila's Braids & Beauty",
      'Braiding',
      'Knotless, cornrows and weaves, at your hostel',
      'Neat, long-lasting braids by a stylist who has worked with UNZA and CBU students since 2019. Bookings open from 07:00.',
      '0977 000 105',
      'Great East Road, near UNZA',
      4.9,
      128,
      Icons.face_3_rounded,
      Color(0xFF9C4B72),
      [
        _Item('Knotless braids (medium)', 350),
        _Item('Cornrows (straight back)', 120),
        _Item('Weave installation', 200),
        _Item('Hostel home visit', 50),
      ],
    ),
    _Vendor(
      'Chanda Cuts Barbershop',
      'Barber Shop',
      'Fades, line-ups and beard trims, walk-ins welcome',
      'Clean cuts at student prices. Open Monday to Saturday, 08:00 to 19:00. Ask about the 5-cut loyalty card.',
      '0977 000 106',
      'Kamwala, Lusaka',
      4.7,
      84,
      Icons.content_cut_rounded,
      Color(0xFF276749),
      [_Item('Low fade', 40), _Item('Beard trim', 20), _Item('Cut + wash', 55)],
    ),
    _Vendor(
      'Fresh Mpongwe Veggies',
      'Vegetables & Fruit',
      'Fresh vegetables delivered to your hostel door',
      'Tomatoes, rape, onions, cabbage and fruit from farms near Lusaka. Order by 18:00 for next-morning delivery.',
      '0977 000 109',
      'Chilenje Market, Lusaka',
      4.8,
      210,
      Icons.eco_rounded,
      Color(0xFF2E8B57),
      [
        _Item('Tomatoes (1kg)', 25),
        _Item('Rape bundle', 10),
        _Item('Weekly student box', 140),
      ],
    ),
    _Vendor(
      'Print & Type Hub',
      'Printing & Typing',
      'Printing, binding, typing and CV design',
      'Assignments, dissertations and CVs printed and bound while you wait.',
      '0977 000 113',
      'Opposite UNZA Main Gate',
      4.5,
      134,
      Icons.print_rounded,
      Color(0xFF6D5A9A),
      [
        _Item('Black and white print', 1),
        _Item('Spiral binding', 25),
        _Item('CV design', 80),
      ],
    ),
    _Vendor(
      'MathsPlus Tutors',
      'Tutoring',
      'Maths, statistics and programming help for first years',
      'One-to-one and small-group tutoring from final-year students, with past-paper practice before exams.',
      '0977 000 116',
      'UNZA Library, Lusaka',
      4.8,
      49,
      Icons.school_rounded,
      Color(0xFFB36B25),
      [
        _Item('One-to-one (1 hour)', 80),
        _Item('Group session', 30),
        _Item('Exam revision pack', 60),
      ],
    ),
  ];

  List<_Vendor> get filtered {
    final q = _query.trim().toLowerCase();
    return [..._mine, ...vendors]
        .where(
          (v) =>
              (_category == 'All' || v.category == _category) &&
              (q.isEmpty ||
                  v.name.toLowerCase().contains(q) ||
                  v.tagline.toLowerCase().contains(q) ||
                  v.category.toLowerCase().contains(q)),
        )
        .toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _nav(int i) {
    if (i == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (i == 1) Navigator.pushReplacementNamed(context, Routes.map);
    if (i == 2) Navigator.pushReplacementNamed(context, Routes.saved);
    if (i == 4) Navigator.pushReplacementNamed(context, Routes.account);
  }

  Future<void> _post() async {
    final listing = await Navigator.of(context).push<_Vendor>(
      MaterialPageRoute(builder: (_) => const _PostServiceScreen()),
    );
    if (!mounted || listing == null) return;
    setState(() {
      _mine.insert(0, listing);
      _category = 'All';
      _query = '';
      _search.clear();
    });
    showSnack(context, 'Your service is now listed in the Market');
  }

  @override
  Widget build(BuildContext context) {
    // The original data-rich implementation remains below for its models and
    // posting flow; the marketplace now uses the dedicated reference layout.
    if (Theme.of(context).platform != TargetPlatform.fuchsia) {
      return const MarketplaceHomeScreen();
    }
    final list = filtered;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 3,
        onTabSelected: _nav,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text(
              'Student Market',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            backgroundColor: Colors.white.withValues(alpha: .78),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.white.withValues(alpha: .55)),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _post,
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: orangePrimary,
                ),
                tooltip: 'Post a service',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: _input(
                  'Search services or vendors',
                  prefix: Icons.search_rounded,
                  suffix: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 62,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  return _FilterButton(
                    label: cat,
                    selected: cat == _category,
                    onTap: () => setState(() => _category = cat),
                  );
                },
              ),
            ),
          ),
          if (_query.isEmpty && _category == 'All')
            SliverToBoxAdapter(
              child: _Promos(
                index: _promo,
                onChanged: (v) => setState(() => _promo = v),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  const Text(
                    'Available near you',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  Text(
                    '${list.length} listings',
                    style: const TextStyle(color: grayText, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          if (list.isEmpty)
            const SliverToBoxAdapter(child: _Empty())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _VendorCard(
                  vendor: list[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _VendorScreen(vendor: list[i]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

InputDecoration _input(String hint, {IconData? prefix, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      prefixIcon: prefix == null ? null : Icon(prefix),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderGray),
      ),
    );

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      backgroundColor: selected ? lightOrange : Colors.white,
      foregroundColor: selected ? orangePrimary : const Color(0xFF53443A),
      side: BorderSide(color: selected ? orangePrimary : borderGray),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 14),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

class _Vendor {
  const _Vendor(
    this.name,
    this.category,
    this.tagline,
    this.description,
    this.phone,
    this.location,
    this.rating,
    this.reviews,
    this.icon,
    this.color,
    this.items, {
    this.cover,
  });
  final String name, category, tagline, description, phone, location;
  final double rating;
  final int reviews;
  final IconData icon;
  final Color color;
  final List<_Item> items;
  final XFile? cover;
}

class _Item {
  const _Item(this.name, this.price, {this.image});
  final String name;
  final int price;
  final XFile? image;
}

class _Promos extends StatelessWidget {
  const _Promos({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;
  static const data = [
    (
      'Find help near campus',
      'From repairs to tutoring, contact local services.',
      Icons.handyman_rounded,
    ),
    (
      'Post what you offer',
      'Turn your skill or small business into a listing.',
      Icons.storefront_rounded,
    ),
    (
      'Student prices',
      'Browse catalogues, then contact the provider.',
      Icons.volunteer_activism_rounded,
    ),
  ];
  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 178,
        child: PageView.builder(
          itemCount: data.length,
          onPageChanged: onChanged,
          itemBuilder: (_, i) {
            final p = data[i];
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    orangePrimary,
                    Color.lerp(orangePrimary, mintGreen, .45)!,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(p.$3, size: 82, color: Colors.white24),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STUDENT SERVICES',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          p.$1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          p.$2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          data.length,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(3),
            height: 7,
            width: index == i ? 21 : 7,
            decoration: BoxDecoration(
              color: index == i ? orangePrimary : borderGray,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
    ],
  );
}

class _VendorCard extends StatelessWidget {
  const _VendorCard({required this.vendor, required this.onTap});
  final _Vendor vendor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .10),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VendorMediaCarousel(vendor: vendor, height: 142),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (vendor.rating > 0)
                        const Icon(
                          Icons.verified_rounded,
                          color: orangePrimary,
                          size: 19,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vendor.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: grayText),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 5,
                    children: [
                      Text(
                        vendor.category,
                        style: const TextStyle(
                          color: orangePrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (vendor.rating > 0)
                        Text(
                          'â˜… ${vendor.rating.toStringAsFixed(1)} (${vendor.reviews})',
                        ),
                      Text('âŒ– ${vendor.location}'),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Text(
                    vendor.items.first.price > 0
                        ? 'From ${kwacha(vendor.items.first.price)}'
                        : 'Ask for price',
                    style: const TextStyle(
                      color: mintGreen,
                      fontWeight: FontWeight.w900,
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

class _VendorImage extends StatelessWidget {
  const _VendorImage({required this.vendor, required this.height});
  final _Vendor vendor;
  final double height;
  @override
  Widget build(BuildContext context) {
    if (vendor.cover != null)
      return _FileImage(
        file: vendor.cover!,
        height: height,
        width: double.infinity,
      );
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [vendor.color, vendor.color.withValues(alpha: .68)],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              vendor.name[0],
              style: TextStyle(
                color: Colors.white.withValues(alpha: .16),
                fontSize: 96,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(vendor.icon, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    vendor.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorMediaCarousel extends StatefulWidget {
  const _VendorMediaCarousel({required this.vendor, required this.height});
  final _Vendor vendor;
  final double height;
  @override
  State<_VendorMediaCarousel> createState() => _VendorMediaCarouselState();
}

class _VendorMediaCarouselState extends State<_VendorMediaCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final count = widget.vendor.items.length + 1;
      _page = (_page + 1) % count;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _page,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = [null, ...widget.vendor.items.map((item) => item.image)];
    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (_, index) => index == 0
                ? _VendorImage(vendor: widget.vendor, height: widget.height)
                : slides[index] == null
                ? Container(
                    color: widget.vendor.color.withValues(alpha: .85),
                    alignment: Alignment.center,
                    child: Icon(
                      widget.vendor.icon,
                      color: Colors.white70,
                      size: 52,
                    ),
                  )
                : _FileImage(
                    file: slides[index]!,
                    width: double.infinity,
                    height: widget.height,
                  ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => Container(
                width: index == _page ? 14 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileImage extends StatelessWidget {
  const _FileImage({
    required this.file,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  final XFile file;
  final double? width, height;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
    future: file.readAsBytes(),
    builder: (_, s) {
      if (!s.hasData)
        return SizedBox(
          width: width,
          height: height,
          child: const ColoredBox(color: lightGray),
        );
      return Image.memory(s.data!, width: width, height: height, fit: fit);
    },
  );
}

class _VendorScreen extends StatelessWidget {
  const _VendorScreen({required this.vendor});
  final _Vendor vendor;
  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: vendor.phone));
    showSnack(context, 'Phone number copied: ${vendor.phone}');
  }

  Future<void> _call(BuildContext context) async {
    final number = vendor.phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final opened = await launchUrl(Uri(scheme: 'tel', path: number));
    if (!opened && context.mounted) _copy(context);
  }

  Future<void> _whatsApp(BuildContext context) async {
    final digits = vendor.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final number = digits.startsWith('0')
        ? '260${digits.substring(1)}'
        : digits;
    final uri = Uri.parse(
      'https://wa.me/$number?text=${Uri.encodeComponent('Hi ${vendor.name}, I found your service on UniStay.')}',
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) _copy(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 250,
          foregroundColor: Colors.white,
          backgroundColor: vendor.color,
          flexibleSpace: FlexibleSpaceBar(
            background: _VendorImage(vendor: vendor, height: 250),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -34),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: orangePrimary,
                    child: Icon(vendor.icon, color: Colors.white, size: 34),
                  ),
                ),
                Text(
                  vendor.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 13,
                  runSpacing: 5,
                  children: [
                    Text(
                      vendor.category,
                      style: const TextStyle(
                        color: orangePrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (vendor.rating > 0)
                      Text(
                        'â˜… ${vendor.rating.toStringAsFixed(1)} (${vendor.reviews} reviews)',
                      ),
                    Text('âŒ– ${vendor.location}'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(vendor.description, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Text(
                      'Catalog',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${vendor.items.length} items',
                      style: const TextStyle(color: grayText),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vendor.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .94,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, i) =>
                      _Catalog(item: vendor.items[i], color: vendor.color),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderGray),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_in_talk_rounded,
                        color: orangePrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PHONE AND WHATSAPP',
                              style: TextStyle(
                                fontSize: 11,
                                color: grayText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              vendor.phone,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _copy(context),
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 52,
                      width: 56,
                      child: OutlinedButton(
                        onPressed: () => _call(context),
                        child: const Icon(Icons.call_rounded),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: () => _whatsApp(context),
                          icon: const Icon(Icons.chat_rounded),
                          label: const Text('Message on WhatsApp'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Catalog extends StatelessWidget {
  const _Catalog({required this.item, required this.color});
  final _Item item;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderGray),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _ImageViewer(item: item, color: color),
              ),
            ),
            child: item.image == null
                ? Container(
                    color: color.withValues(alpha: .14),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 40,
                      color: color,
                    ),
                  )
                : _FileImage(file: item.image!, width: double.infinity),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                item.price > 0 ? kwacha(item.price) : 'Ask for price',
                style: const TextStyle(
                  color: mintGreen,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.item, required this.color});
  final _Item item;
  final Color color;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: item.image == null
              ? Icon(Icons.inventory_2_rounded, color: color, size: 120)
              : InteractiveViewer(
                  child: _FileImage(
                    file: item.image!,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
            child: Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(42),
    child: Column(
      children: [
        Icon(Icons.search_off_rounded, size: 56, color: orangePrimary),
        SizedBox(height: 12),
        Text(
          'No services found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 6),
        Text(
          'Try another search or category.',
          style: TextStyle(color: grayText),
        ),
      ],
    ),
  );
}

class _PostServiceScreen extends StatefulWidget {
  const _PostServiceScreen();
  @override
  State<_PostServiceScreen> createState() => _PostServiceScreenState();
}

class _PostServiceScreenState extends State<_PostServiceScreen> {
  final _form = GlobalKey<FormState>(), _picker = ImagePicker();
  final _name = TextEditingController(),
      _phone = TextEditingController(),
      _location = TextEditingController(),
      _tagline = TextEditingController(),
      _about = TextEditingController();
  final List<_Draft> _items = [_Draft()];
  String? _category;
  XFile? _cover;
  @override
  void dispose() {
    for (final c in [_name, _phone, _location, _tagline, _about]) {
      c.dispose();
    }
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  Future<void> _image({int? item}) async {
    final f = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: item == null ? 1600 : 1000,
      imageQuality: 82,
    );
    if (f != null && mounted)
      setState(() {
        if (item == null)
          _cover = f;
        else
          _items[item].image = f;
      });
  }

  void _publish() {
    if (!_form.currentState!.validate() || _category == null) {
      showSnack(
        context,
        _category == null
            ? 'Choose a service category'
            : 'Complete the required details',
      );
      return;
    }
    final services = _items
        .where((i) => i.name.text.trim().isNotEmpty)
        .map(
          (i) => _Item(
            i.name.text.trim(),
            int.tryParse(i.price.text.trim()) ?? 0,
            image: i.image,
          ),
        )
        .toList();
    Navigator.pop(
      context,
      _Vendor(
        _name.text.trim(),
        _category!,
        _tagline.text.trim(),
        _about.text.trim(),
        _phone.text.trim(),
        _location.text.trim(),
        0,
        0,
        Icons.storefront_rounded,
        orangePrimary,
        services.isEmpty
            ? const [_Item('Contact vendor for pricing', 0)]
            : services,
        cover: _cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Post your service',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _publish,
          icon: const Icon(Icons.publish_rounded),
          label: const Text('Publish profile'),
        ),
      ),
    ),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'Create a profile students can browse, call and message.',
            style: TextStyle(color: grayText),
          ),
          const SizedBox(height: 18),
          _Pick(
            label: 'Cover photo',
            file: _cover,
            tap: () => _image(),
            wide: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _name,
            decoration: _input('Business or your name'),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Enter your name or business'
                : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: _input('Category'),
            items: _MarketScreenState.categories
                .where((c) => c != 'All')
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: _input('Phone and WhatsApp number'),
            validator: (v) => v == null || v.trim().length < 9
                ? 'Enter a valid phone number'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _location,
            decoration: _input('Where you work'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter your location' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _tagline,
            maxLength: 80,
            decoration: _input('One-line pitch'),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Tell students what you offer'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _about,
            maxLines: 4,
            maxLength: 400,
            decoration: _input('About you (hours, experience, call-outs)'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Catalog: what you sell or do',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add individual services, prices and optional photos.',
            style: TextStyle(color: grayText),
          ),
          const SizedBox(height: 12),
          ..._items.asMap().entries.map(
            (e) => _DraftEditor(
              draft: e.value,
              photo: () => _image(item: e.key),
              remove: _items.length == 1
                  ? null
                  : () => setState(() {
                      e.value.dispose();
                      _items.removeAt(e.key);
                    }),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _items.length >= 12
                ? null
                : () => setState(() => _items.add(_Draft())),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add item or service'),
          ),
          const SizedBox(height: 26),
        ],
      ),
    ),
  );
}

class _Draft {
  final name = TextEditingController(), price = TextEditingController();
  XFile? image;
  void dispose() {
    name.dispose();
    price.dispose();
  }
}

class _Pick extends StatelessWidget {
  const _Pick({
    required this.label,
    required this.file,
    required this.tap,
    this.wide = false,
  });
  final String label;
  final XFile? file;
  final VoidCallback tap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
        ],
        InkWell(
          onTap: tap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: wide ? double.infinity : 62,
            height: wide ? 145 : 62,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: file == null ? dottedLineGray : orangePrimary,
              ),
            ),
            child: file == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: orangePrimary,
                        ),
                        if (wide)
                          const Text(
                            'Add a cover photo',
                            style: TextStyle(color: grayText),
                          ),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      _FileImage(file: file!),
                      if (wide)
                        Container(
                          color: Colors.black38,
                          alignment: Alignment.center,
                          child: const Text(
                            'Change photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _DraftEditor extends StatelessWidget {
  const _DraftEditor({required this.draft, required this.photo, this.remove});
  final _Draft draft;
  final VoidCallback photo;
  final VoidCallback? remove;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pick(label: '', file: draft.image, tap: photo),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: draft.name,
                decoration: const InputDecoration(
                  hintText: 'Item or service name',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 7),
              TextField(
                controller: draft.price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Price in Kwacha (optional)',
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        if (remove != null)
          IconButton(
            onPressed: remove,
            icon: const Icon(Icons.close_rounded, color: grayText),
          ),
      ],
    ),
  );
}


