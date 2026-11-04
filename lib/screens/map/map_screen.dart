part of '../../main.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final searchController = TextEditingController();
  GoogleMapController? mapController;
  LatLng marker = unistayInitialLatLng;
  String markerLabel = 'Lusaka';

  @override
  void dispose() {
    mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  void search() {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      showSnack(context, 'Location not found');
      return;
    }
    final hash = query.codeUnits.fold<int>(
      0,
      (previous, value) => previous + value,
    );
    final nextMarker = LatLng(
      -15.455 + (hash % 90) / 1000,
      28.255 + (hash % 120) / 1000,
    );
    setState(() {
      marker = nextMarker;
      markerLabel = query;
    });
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(nextMarker, 14.5));
    showSnack(context, 'Map centered on $query');
  }

  void selectTab(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (index == 2) Navigator.pushReplacementNamed(context, Routes.saved);
    if (index == 3) Navigator.pushReplacementNamed(context, Routes.account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UniBottomNavigationDock(
        selectedTabIndex: 1,
        onTabSelected: selectTab,
      ),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => search(),
                decoration: InputDecoration(
                  hintText: 'Search for locations',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: search,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: kIsWeb
                ? MockMap(marker: const Offset(0.5, 0.5), markerLabel: markerLabel)
                : GoogleMap(
                    initialCameraPosition: unistayInitialCameraPosition,
                    onMapCreated: (controller) => mapController = controller,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected-location'),
                        position: marker,
                        infoWindow: InfoWindow(title: markerLabel),
                      ),
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
