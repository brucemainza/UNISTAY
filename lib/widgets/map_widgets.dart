part of '../main.dart';

const unistayInitialLatLng = LatLng(-15.3922, 28.3228);
const unistayInitialCameraPosition = CameraPosition(
  target: unistayInitialLatLng,
  zoom: 13.5,
);

class GoogleMapWarmup extends StatelessWidget {
  const GoogleMapWarmup({super.key});

  @override
  Widget build(BuildContext context) {
    // Google Maps for Web requires a Maps JavaScript API key.
    // Skip the warmup on web to avoid crashes in development.
    if (kIsWeb) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      top: 0,
      width: 1,
      height: 1,
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: Opacity(
            opacity: 0.01,
            child: GoogleMap(
              initialCameraPosition: unistayInitialCameraPosition,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              liteModeEnabled: true,
            ),
          ),
        ),
      ),
    );
  }
}

class MockMap extends StatelessWidget {
  const MockMap({super.key, required this.marker, required this.markerLabel});

  final Offset marker;
  final String markerLabel;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MapPainter(marker: marker, markerLabel: markerLabel),
      child: const SizedBox.expand(),
    );
  }
}

class MapPainter extends CustomPainter {
  MapPainter({required this.marker, required this.markerLabel});

  final Offset marker;
  final String markerLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFEAF0E7);
    canvas.drawRect(Offset.zero & size, background);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    final thinRoadPaint = Paint()
      ..color = const Color(0xFFD7E0D3)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 7; i++) {
      final y = size.height * (0.16 + i * 0.12);
      canvas.drawLine(
        Offset(-40, y),
        Offset(size.width + 40, y + ((i.isEven ? 1 : -1) * 36)),
        roadPaint,
      );
      canvas.drawLine(
        Offset(-40, y),
        Offset(size.width + 40, y + ((i.isEven ? 1 : -1) * 36)),
        thinRoadPaint,
      );
    }
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.16 + i * 0.18);
      canvas.drawLine(
        Offset(x, -20),
        Offset(x + 54, size.height + 20),
        roadPaint,
      );
      canvas.drawLine(
        Offset(x, -20),
        Offset(x + 54, size.height + 20),
        thinRoadPaint,
      );
    }

    final water = Paint()..color = const Color(0xFFB9DCF5);
    final path = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.58,
        size.width * 0.5,
        size.height * 0.76,
        size.width,
        size.height * 0.62,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, water);

    final markerCenter = Offset(
      size.width * marker.dx,
      size.height * marker.dy,
    );
    final markerPaint = Paint()..color = orangePrimary;
    canvas.drawCircle(markerCenter, 14, markerPaint);
    canvas.drawCircle(markerCenter, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.marker != marker ||
        oldDelegate.markerLabel != markerLabel;
  }
}
