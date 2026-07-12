part of '../../main.dart';

class HouseDetailScreen extends StatelessWidget {
  const HouseDetailScreen({super.key, required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final similar = houses.where((item) => item.name != house.name).toList();
    final related = similar.isEmpty ? houses : similar;

    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: bottomPadding + 80),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            scrollCacheExtent: const ScrollCacheExtent.pixels(1000),
            children: [
              _DetailHero(house: house),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Column(
                  children: [
                    _HouseSummaryCard(house: house),
                    const SizedBox(height: 14),
                    _AmenitiesPanel(amenities: house.amenities),
                    const SizedBox(height: 30),
                    const _AboutHousePanel(),
                    const SizedBox(height: 14),
                    _HorizontalHouseSection(
                      title: 'Similar Properties',
                      houses: related,
                    ),
                    const SizedBox(height: 14),
                    _HorizontalHouseSection(
                      title: 'Nearby Houses',
                      houses: related.reversed.toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: topPadding + 12,
            left: 14,
            child: _RoundIconButton(
              icon: Icons.keyboard_arrow_left_rounded,
              iconSize: 34,
              color: Colors.black,
              background: Colors.white.withValues(alpha: 0.80),
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: topPadding + 14,
            right: 18,
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFE9003F),
              size: 42,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: orangePrimary, width: 2),
                        foregroundColor: orangePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        showSnack(context, 'Enquire about ${house.name}');
                      },
                      child: const Text(
                        'Enquire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        Routes.roomList,
                        arguments: house,
                      ),
                      child: const Text(
                        'View Rooms',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailHero extends StatefulWidget {
  const _DetailHero({required this.house});

  final House house;

  @override
  State<_DetailHero> createState() => _DetailHeroState();
}

class _DetailHeroState extends State<_DetailHero> {
  late final PageController _pageController = PageController();
  int _activePage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_activePage + 1) % widget.house.imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HouseImageViewerPage(
          house: widget.house,
          initialPage: _activePage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 334,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _openFullscreen,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.house.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _activePage = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.house.imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _PropertyFallback(house: widget.house);
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _PropertyFallback(house: widget.house),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.house.imageUrls.length, (index) {
                final active = index == _activePage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 10,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 54,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: Color(0xFFFFC107),
                  ),
                  Text(
                    widget.house.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HouseImageViewerPage extends StatefulWidget {
  const HouseImageViewerPage({
    super.key,
    required this.house,
    required this.initialPage,
  });

  final House house;
  final int initialPage;

  @override
  State<HouseImageViewerPage> createState() => _HouseImageViewerPageState();
}

class _HouseImageViewerPageState extends State<HouseImageViewerPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.house.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Image.network(
                    widget.house.imageUrls[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 14,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HouseSummaryCard extends StatelessWidget {
  const _HouseSummaryCard({required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    return _DetailPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                _DetailInfoLine(
                  icon: Icons.location_on_outlined,
                  text: house.location.toLowerCase(),
                ),
                const SizedBox(height: 6),
                _DetailInfoLine(
                  icon: Icons.directions_walk_rounded,
                  text: '${house.walkTime} from nearest school',
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${kwacha(house.price)}/mo',
                        style: const TextStyle(
                          color: mintGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.map),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: orangePrimary,
                        side: const BorderSide(color: orangePrimary),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(74, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View map',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFCFCFCF)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEED8),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(19)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final uni in house.nearbyUniversities)
                      _MiniBadge(
                        icon: Icons.school_outlined,
                        text: '${uni.name} ${uni.distance}',
                      ),
                    for (final method in house.paymentMethods)
                      _MiniBadge(
                        icon: _paymentIcon(method),
                        text: method,
                        color: method.toLowerCase().contains('no')
                            ? const Color(0xFFFFC5C5)
                            : const Color(0xFFD9FFC5),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: orangePrimary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(78, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconAlignment: IconAlignment.end,
                    label: const Text(
                      'View all',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    icon: const Icon(Icons.chevron_right_rounded, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _paymentIcon(String method) {
    final lower = method.toLowerCase();
    if (lower.contains('no')) return Icons.money_off_csred_outlined;
    if (lower.contains('visa') || lower.contains('bank')) {
      return Icons.credit_card_outlined;
    }
    return Icons.paid_rounded;
  }
}

class _AmenitiesPanel extends StatefulWidget {
  const _AmenitiesPanel({required this.amenities});

  final List<String> amenities;

  @override
  State<_AmenitiesPanel> createState() => _AmenitiesPanelState();
}

class _AmenitiesPanelState extends State<_AmenitiesPanel> {
  bool _expanded = false;

  static const _defaultItems = [
    _AmenityItem(Icons.tv_outlined, 'TV Room'),
    _AmenityItem(Icons.ac_unit_rounded, 'Air condition'),
    _AmenityItem(Icons.wifi_rounded, 'Wifi'),
    _AmenityItem(Icons.cleaning_services_outlined, 'House cleaner'),
    _AmenityItem(Icons.menu_book_outlined, 'Study Area'),
    _AmenityItem(Icons.sports_esports_outlined, 'Gaming/Recreation room'),
    _AmenityItem(Icons.solar_power_outlined, 'Backup power'),
    _AmenityItem(Icons.security_rounded, '24/7 security'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _defaultItems;
    final visibleItems = _expanded ? items : items.take(4).toList();

    return _DetailPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Text(
              'Amenities',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFCFCFCF)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Text(
              '*ameneties included in rent',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 0, 16, 12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 42,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => visibleItems[index],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E2E2)),
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(foregroundColor: orangePrimary),
              iconAlignment: IconAlignment.end,
              label: Text(
                _expanded ? 'view less amenities' : 'view all amenities',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              icon: AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHousePanel extends StatefulWidget {
  const _AboutHousePanel();

  @override
  State<_AboutHousePanel> createState() => _AboutHousePanelState();
}

class _AboutHousePanelState extends State<_AboutHousePanel> {
  bool _expanded = false;

  static const _fullText =
      'Besides, the initial progress in the principles of effective '
      'management indicates the importance of The Diversity of '
      'Incorporative Uptake\n'
      '(Moises Ouidry in The Book of the Ability Bias)\n\n'
      'As for details of the functional programming, it is clear that '
      'the strategic decisions in its influence on elements of the '
      'vital decisions should correlate with the conceptual design.\n'
      'In addition, criteria of a huge improvement of the first-class '
      'package shows a stable performance in development of the continuing area.';

  @override
  Widget build(BuildContext context) {
    return _DetailPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'About the house',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFCFCFCF)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: AnimatedCrossFade(
              firstChild: Text(
                _fullText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF3D3D3D),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              secondChild: Text(
                _fullText,
                style: const TextStyle(
                  color: Color(0xFF3D3D3D),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded ? 'see less' : 'see more',
                    style: const TextStyle(
                      color: orangePrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalHouseSection extends StatelessWidget {
  const _HorizontalHouseSection({required this.title, required this.houses});

  final String title;
  final List<House> houses;

  @override
  Widget build(BuildContext context) {
    return _DetailPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE1E1E1)),
          SizedBox(
            height: 288,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              scrollDirection: Axis.horizontal,
              primary: false,
              physics: const BouncingScrollPhysics(),
              itemCount: houses.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return _CompactHouseCard(house: houses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactHouseCard extends StatefulWidget {
  const _CompactHouseCard({required this.house});

  final House house;

  @override
  State<_CompactHouseCard> createState() => _CompactHouseCardState();
}

class _CompactHouseCardState extends State<_CompactHouseCard> {
  int _activeImage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final house = widget.house;
    return SizedBox(
      width: 230,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.pushReplacementNamed(
            context,
            Routes.houseDetail,
            arguments: house,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: orangePrimary.withValues(alpha: 0.5), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: house.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() => _activeImage = index);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            house.imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _PropertyFallback(house: house),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            house.imageUrls.length,
                            (index) {
                              final active = index == _activeImage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: active ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.55),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: FavoriteHeart(isFavorite: true, size: 22),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          house.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                house.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                '${kwacha(house.price)}/mo',
                                style: const TextStyle(
                                  color: mintGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: Color(0xFFFFC107),
                            ),
                            Text(
                              house.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 11),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.17),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DetailInfoLine extends StatelessWidget {
  const _DetailInfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 25, color: Colors.black),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.icon,
    required this.text,
    this.color = const Color(0xFFFFDFB6),
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  const _AmenityItem(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 27, color: const Color(0xFF303030)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF4A4A4A)),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.color,
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }
}
