part of '../main.dart';

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E2E2),
      highlightColor: Colors.white,
      period: const Duration(milliseconds: 1300),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: orangePrimary,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 12,
                16,
                12,
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      _SkeletonBlock(width: 110, height: 22, borderRadius: 8),
                      Spacer(),
                      _SkeletonBlock(width: 28, height: 28, borderRadius: 14),
                    ],
                  ),
                  SizedBox(height: 12),
                  _SkeletonBlock(
                    width: double.infinity,
                    height: 48,
                    borderRadius: 24,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _SkeletonBlock(
                width: double.infinity,
                height: 92,
                borderRadius: 14,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _SkeletonBlock(width: 138, height: 34, borderRadius: 18),
                  SizedBox(width: 10),
                  _SkeletonBlock(width: 80, height: 34, borderRadius: 18),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: _SkeletonBlock(width: 150, height: 22, borderRadius: 8),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (_, _) => const _SkeletonHouseCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonHouseCard extends StatelessWidget {
  const _SkeletonHouseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0ECE6)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBlock(width: double.infinity, height: 180, borderRadius: 12),
          SizedBox(height: 12),
          _SkeletonBlock(width: 170, height: 18, borderRadius: 8),
          SizedBox(height: 10),
          _SkeletonBlock(width: 110, height: 14, borderRadius: 7),
          SizedBox(height: 10),
          _SkeletonBlock(width: 85, height: 18, borderRadius: 8),
        ],
      ),
    );
  }
}

class OrderLoadingSkeleton extends StatelessWidget {
  const OrderLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.96),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE2E2E2),
        highlightColor: Colors.white,
        period: const Duration(milliseconds: 1300),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SkeletonBlock(width: 92, height: 92, borderRadius: 46),
                const SizedBox(height: 24),
                const _SkeletonBlock(width: 210, height: 24, borderRadius: 8),
                const SizedBox(height: 12),
                const _SkeletonBlock(width: 280, height: 16, borderRadius: 8),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGray),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    children: [
                      _SkeletonBlock(
                        width: double.infinity,
                        height: 18,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 12),
                      _SkeletonBlock(
                        width: double.infinity,
                        height: 18,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 12),
                      _SkeletonBlock(width: 180, height: 18, borderRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Processing your order…',
                  style: TextStyle(color: grayText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
