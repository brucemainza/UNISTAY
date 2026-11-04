part of '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.minDisplayDuration = const Duration(milliseconds: 2200),
  });

  final Duration minDisplayDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Avoid double initialization if the widget rebuilds quickly.
    if (_initialized) return;
    _initialized = true;

    // Minimum branding display time.
    await Future.delayed(widget.minDisplayDuration);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, _resolveStartupRoute());
  }

  String _resolveStartupRoute() {
    // TODO: replace with a secure storage / token lookup.
    return Routes.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: orangePrimary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: const Text(
                    'UniStay',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: orangePrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: const Text(
                    'Zambia student housing',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grayText,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Your campus. Your place.',
              style: TextStyle(color: grayText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
