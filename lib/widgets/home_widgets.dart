part of '../main.dart';

// ─── Ad Carousel ─────────────────────────────────────────────────────────────

class AdCarousel extends StatefulWidget {
  const AdCarousel({super.key, required this.controller});

  final PageController controller;

  @override
  State<AdCarousel> createState() => _AdCarouselState();
}

class _AdCarouselState extends State<AdCarousel> {
  int _currentPage = 0;

  static const _ads = [
    _AdSlide(
      headline: 'Get accommodation the\neasy way',
      highlight: 'accommodation',
      imageUrl:
          'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=900&q=80',
    ),
    _AdSlide(
      headline: 'Compare prices near\nyour campus',
      highlight: 'prices',
      imageUrl:
          'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=900&q=80',
    ),
    _AdSlide(
      headline: 'Book secure student\nrooms fast',
      highlight: 'secure',
      imageUrl:
          'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?auto=format&fit=crop&w=900&q=80',
    ),
    _AdSlide(
      headline: 'Find affordable housing\nin your city',
      highlight: 'affordable',
      imageUrl:
          'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?auto=format&fit=crop&w=900&q=80',
    ),
    _AdSlide(
      headline: 'Student life made\neasy',
      highlight: 'easy',
      imageUrl:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChange);
  }

  void _onPageChange() {
    final page = widget.controller.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: 5,
            pageSnapping: true,
            itemBuilder: (context, index) => _AdCard(slide: _ads[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final active = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 24 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? orangePrimary
                    : Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _AdSlide {
  final String headline;
  final String highlight;
  final String imageUrl;

  const _AdSlide({
    required this.headline,
    required this.highlight,
    required this.imageUrl,
  });
}

class _AdCard extends StatelessWidget {
  const _AdCard({required this.slide});

  final _AdSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightOrange,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            slide.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return ColoredBox(color: lightOrange);
            },
          ),
          // Dark overlay for text visibility
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.12),
                  ],
                ),
              ),
            ),
          ),
          // Headline text
          Positioned(
            left: 26,
            right: 80,
            top: 36,
            child: _AdHeadline(slide: slide),
          ),
        ],
      ),
    );
  }
}

class _AdHeadline extends StatelessWidget {
  const _AdHeadline({required this.slide});

  final _AdSlide slide;

  @override
  Widget build(BuildContext context) {
    final parts = slide.headline.split(slide.highlight);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: slide.highlight,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: orangePrimary,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.last),
        ],
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ─── House Card ───────────────────────────────────────────────────────────────

class HouseCard extends StatefulWidget {
  const HouseCard({super.key, required this.house, required this.onTap});

  final House house;
  final VoidCallback onTap;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  bool _isFavorite = false;
  int _activeImage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.house.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() => _activeImage = index);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.house.imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _PropertyFallback(house: widget.house),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.house.imageUrls.length,
                            (index) {
                              final active = index == _activeImage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: active ? 24 : 8,
                                height: 8,
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
                      Positioned(
                        top: 12,
                        right: 12,
                        child: FavoriteHeart(
                          isFavorite: _isFavorite,
                          size: 26,
                          onTap: () {
                            setState(() => _isFavorite = !_isFavorite);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.house.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.house.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.directions_walk_rounded,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${widget.house.walkTime} from ${widget.house.university == 'University of Zambia' ? 'unza' : widget.house.university.split(' ').first.toLowerCase()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${kwacha(widget.house.price)}/mo',
                      style: const TextStyle(
                        color: mintGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final amenity in widget.house.amenities.take(4))
                          FeatureTag(
                            label: amenity,
                            icon: _amenityIcon(amenity),
                          ),
                      ],
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

  IconData? _amenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wifi')) return Icons.wifi_rounded;
    if (lower.contains('water')) return Icons.water_drop_outlined;
    if (lower.contains('security')) return Icons.security_rounded;
    if (lower.contains('parking') || lower.contains('car')) {
      return Icons.local_parking_rounded;
    }
    if (lower.contains('kitchen')) return Icons.kitchen_outlined;
    if (lower.contains('power')) return Icons.solar_power_outlined;
    if (lower.contains('laundry')) return Icons.local_laundry_service_outlined;
    if (lower.contains('study')) return Icons.menu_book_outlined;
    return Icons.check_rounded;
  }
}

// ─── Property Hero ────────────────────────────────────────────────────────────

class PropertyHero extends StatelessWidget {
  const PropertyHero({
    super.key,
    required this.house,
    required this.height,
    this.showFavorite = true,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  final House house;
  final double height;
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            house.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _PropertyFallback(house: house);
            },
            errorBuilder: (context, error, stackTrace) =>
                _PropertyFallback(house: house),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.24),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (showFavorite)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onFavoritePressed,
                child: Container(
                  width: height > 200 ? 44 : 38,
                  height: height > 200 ? 44 : 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: isFavorite
                          ? const Color(0xFFE9003F)
                          : Colors.white.withValues(alpha: 0.8),
                      size: height > 200 ? 24 : 20,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
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

class _PropertyFallback extends StatelessWidget {
  const _PropertyFallback({required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            house.accent.withValues(alpha: 0.65),
            lightOrange,
            Colors.white,
          ],
        ),
      ),
    );
  }
}
