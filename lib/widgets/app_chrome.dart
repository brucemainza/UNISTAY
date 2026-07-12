part of '../main.dart';

class UniAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UniAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left, size: 34),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title),
    );
  }
}

class CompactSearchField extends StatefulWidget {
  const CompactSearchField({super.key});

  @override
  State<CompactSearchField> createState() => _CompactSearchFieldState();
}

class _CompactSearchFieldState extends State<CompactSearchField> {
  static const hints = ['Search Home', 'Search House', 'Search Area'];
  Timer? hintTimer;
  int hintIndex = 0;

  @override
  void initState() {
    super.initState();
    hintTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => hintIndex = (hintIndex + 1) % hints.length);
    });
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: '',
              suffixIcon: const Icon(
                Icons.search_rounded,
                size: 36,
                color: Colors.black,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.95),
              contentPadding: const EdgeInsets.fromLTRB(34, 0, 12, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: orangePrimary.withValues(alpha: 0.18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: orangePrimary),
              ),
            ),
          ),
          Positioned(
            left: 34,
            right: 50,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Align(
                  key: ValueKey<int>(hintIndex),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hints[hintIndex],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class UniBottomNavigationBar extends StatelessWidget {
  const UniBottomNavigationBar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  static const _tabs = [
    _NavTab(
      icon: Icons.explore_rounded,
      outlinedIcon: Icons.explore_outlined,
      label: 'Explore',
    ),
    _NavTab(
      icon: Icons.map_rounded,
      outlinedIcon: Icons.map_outlined,
      label: 'Map',
    ),
    _NavTab(
      icon: Icons.person_rounded,
      outlinedIcon: Icons.person_outline_rounded,
      label: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
          height: 64,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final selected = selectedTabIndex == i;
              return Expanded(
                child: _NavItem(
                  tab: _tabs[i],
                  selected: selected,
                  onTap: () => onTabSelected(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final IconData outlinedIcon;
  final String label;
  const _NavTab({
    required this.icon,
    required this.outlinedIcon,
    required this.label,
  });
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _NavTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? orangePrimary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              selected ? tab.icon : tab.outlinedIcon,
              color: selected ? orangePrimary : const Color(0xFFAAAAAA),
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? orangePrimary : const Color(0xFFAAAAAA),
            ),
            child: Text(tab.label),
          ),
        ],
      ),
    );
  }
}

/// Drop this into your Scaffold's bottomNavigationBar slot directly.
/// UniBottomNavigationDock is kept for backward compat but just wraps the bar.
class UniBottomNavigationDock extends StatelessWidget {
  const UniBottomNavigationDock({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return UniBottomNavigationBar(
      selectedTabIndex: selectedTabIndex,
      onTabSelected: onTabSelected,
    );
  }
}


