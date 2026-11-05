part of '../main.dart';

class UniStayApp extends StatelessWidget {
  const UniStayApp({
    super.key,
    this.splashMinDisplay,
  });

  final Duration? splashMinDisplay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniStay',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [child ?? const SizedBox.shrink(), const GoogleMapWarmup()],
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: orangePrimary,
          primary: orangePrimary,
          secondary: mintGreen,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: orangePrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: orangePrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: orangePrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: orangePrimary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        Widget screen;
        switch (settings.name) {
          case Routes.splash:
            screen = SplashScreen(
              minDisplayDuration: splashMinDisplay ??
                  const Duration(milliseconds: 2200),
            );
          case Routes.login:
            screen = const LoginScreen();
          case Routes.signup:
            screen = const SignUpScreen();
          case Routes.verification:
            screen = VerificationScreen(
              role: args is Map
                  ? args['role'] as String? ?? 'Student'
                  : args is String
                  ? args
                  : 'Student',
              email: args is Map
                  ? args['email'] as String? ?? 'student@unza.zm'
                  : 'student@unza.zm',
            );
          case Routes.home:
            screen = const StudentHomeScreen();
          case Routes.saved:
            screen = const SavedScreen();
          case Routes.houseDetail:
            screen = HouseDetailScreen(
              house: args is House ? args : houses.first,
            );
          case Routes.roomList:
            screen = RoomListScreen(house: args is House ? args : houses.first);
          case Routes.enquire:
            screen = EnquireScreen(room: args is Room ? args : rooms.first);
          case Routes.bookingCalendar:
            screen = BookingCalendarScreen(
              room: args is Room ? args : rooms.first,
            );
          case Routes.payment:
            screen = PaymentScreen(room: args is Room ? args : rooms.first);
          case Routes.bookingSummary:
            screen = BookingSummaryScreen(room: args is Room ? args : rooms.first);
          case Routes.processing:
            screen = const ProcessingScreen();
          case Routes.failed:
            screen = const FailedPaymentScreen();
          case Routes.bookingDetail:
            screen = const BookingDetailScreen();
          case Routes.offline:
            screen = const OfflineScreen();
          case Routes.error:
            screen = const ErrorStateScreen();
          case Routes.success:
            screen = const SuccessScreen();
          case Routes.receipt:
            screen = const ReceiptScreen();
          case Routes.account:
            screen = const AccountScreen();
          case Routes.profile:
            screen = const ProfileScreen();
          case Routes.myAccommodation:
            screen = const MyAccommodationScreen();
          case Routes.customerCare:
            screen = const CustomerCareScreen();
          case Routes.settings:
            screen = const SettingsScreen();
          case Routes.map:
            screen = const MapScreen();
          case Routes.notifications:
            screen = const NotificationsScreen();
          case Routes.market:
            screen = const MarketScreen();
          case Routes.serviceProfile:
            screen = const ServiceProfileScreen();
          case Routes.postService:
            screen = const PostServiceScreen();
          case Routes.myServices:
            screen = const MyServicesScreen();
          case Routes.manageCatalog:
            screen = const ManageCatalogScreen();
          case Routes.addCatalogItem:
            screen = const CatalogItemScreen();
          case Routes.editCatalogItem:
            screen = const CatalogItemScreen(editing: true);
          case Routes.editService:
            screen = const EditServiceScreen();
          case Routes.allReviews:
            screen = const AllReviewsScreen();
          case Routes.rateService:
            screen = const RateServiceScreen();
          case Routes.reviewSubmitted:
            screen = const ReviewSubmittedScreen();
          case Routes.universitySearch:
            screen = const UniversitySearchScreen();
          case Routes.filters:
            screen = FilterScreen(
              initialFilters: args is List<String> ? args : const [],
            );
          case Routes.lencoTest:
            screen = PaymentScreen(room: rooms.first, devMode: true);
          case Routes.landlordHome:
            screen = const LandlordHomeScreen();
          case Routes.landlordHouseDetail:
            screen = LandlordHouseDetailScreen(
              house: args is House ? args : houses.first,
            );
          case Routes.landlordRooms:
            screen = const LandlordRoomsScreen();
          case Routes.landlordAmenities:
            screen = const LandlordAmenitiesScreen();
          case Routes.landlordProfile:
            screen = const LandlordProfileScreen();
          case Routes.landlordPaymentDetails:
            screen = const LandlordPaymentDetailsScreen();
          case Routes.landlordHouseRegSuccess:
            screen = const LandlordRegistrationSuccessScreen();
          default:
            screen = const LoginScreen();
        }
        return MaterialPageRoute(builder: (_) => screen, settings: settings);
      },
    );
  }
}
