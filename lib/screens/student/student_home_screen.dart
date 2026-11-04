part of '../../main.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final pageController = PageController();
  final viewModel = HomeViewModel();
  Timer? adTimer;

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChanged);
    viewModel.loadHouses();

    adTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !pageController.hasClients) return;
      final nextPage = (viewModel.adPage + 1) % 3;
      viewModel.setAdPage(nextPage);
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    adTimer?.cancel();
    pageController.dispose();
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void selectTab(int index) {
    if (index == 1) Navigator.pushNamed(context, Routes.map);
    if (index == 2) Navigator.pushNamed(context, Routes.saved);
    if (index == 3) Navigator.pushNamed(context, Routes.account);
  }

  Future<void> selectUniversity() async {
    final result = await Navigator.pushNamed(context, Routes.universitySearch);
    if (!mounted || result is! UniversityOption) return;
    viewModel.selectUniversity(result);
  }

  Future<void> selectFilters() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          FilterScreen(initialFilters: viewModel.activeFilters.toList()),
    );
    if (!mounted || result is! List<String>) return;
    viewModel.setFilters(result);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 0,
        onTabSelected: selectTab,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.loadHouses,
        color: orangePrimary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HomeHeaderDelegate(
                topPadding: topPadding,
                location: viewModel.selectedUniversity?.name ?? 'Lusaka',
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: AdCarousel(controller: pageController)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _UniversityButton(
                            university: viewModel.selectedUniversity,
                            onTap: selectUniversity,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ActionChipButton(
                            icon: Icons.tune_rounded,
                            label: 'Filters',
                            onTap: selectFilters,
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.selectedUniversity != null ||
                        viewModel.activeFilters.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final filter in viewModel.activeFilters)
                            FilterPill(
                              label: filter,
                              onRemove: () => viewModel.removeFilter(filter),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      'Explore houses',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF101010),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            _buildHouseSliverList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseSliverList() {
    if (viewModel.loading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        sliver: SliverList.list(
          children: const [
            _HouseSkeleton(),
            SizedBox(height: 14),
            _HouseSkeleton(),
          ],
        ),
      );
    }

    if (viewModel.error != null) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              Text(
                viewModel.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: viewModel.loadHouses,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.houses.isEmpty) {
      return const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 32),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              'No houses found. Try adjusting your filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: grayText),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      sliver: SliverList.separated(
        itemCount: viewModel.houses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final house = viewModel.houses[index];
          return HouseCard(
            house: house,
            onTap: () => Navigator.pushNamed(
              context,
              Routes.houseDetail,
              arguments: house,
            ),
          );
        },
      ),
    );
  }
}

class _UniversityButton extends StatelessWidget {
  const _UniversityButton({required this.university, required this.onTap});

  final UniversityOption? university;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(
        Icons.school_outlined,
        size: 25,
        color: Color(0xFF2B2B2B),
      ),
      label: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          university?.name ?? 'University or college',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF303030),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF303030),
        backgroundColor: Colors.white,
        side: const BorderSide(color: orangePrimary),
        minimumSize: const Size.fromHeight(36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HomeHeaderDelegate({required this.topPadding, required this.location});

  final double topPadding;
  final String location;

  @override
  // The expanded header contains a title row, a search field, and its vertical
  // padding. Keep this in sync with that content; a larger extent makes Flutter
  // try to pin space that the child cannot paint.
  double get maxExtent => topPadding + 120;

  @override
  double get minExtent => topPadding + 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final collapseRange = maxExtent - minExtent;
    final isCollapsed = shrinkOffset >= collapseRange - 24;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: isCollapsed ? _buildCollapsed(context) : _buildExpanded(context),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final effectiveCollapsed = screenHeight < minExtent + 80;
    final foreground = effectiveCollapsed ? Colors.black : Colors.white;

    return Container(
      key: const ValueKey('expanded-header'),
      color: orangePrimary,
      padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 6),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'UniStay',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.notifications),
                  tooltip: 'Notifications',
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: foreground,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const CompactSearchField(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return ClipRect(
      key: const ValueKey('collapsed-header'),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.42),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.black, size: 22),
              const SizedBox(width: 6),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: CompactSearchField()),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.notifications),
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.topPadding != topPadding ||
        oldDelegate.location != location;
  }
}

class _HouseSkeleton extends StatelessWidget {
  const _HouseSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE2E2E2),
        highlightColor: Colors.white,
        period: const Duration(milliseconds: 1300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 80,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
