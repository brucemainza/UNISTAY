part of '../../main.dart';

class CustomerCareScreen extends StatelessWidget {
  const CustomerCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Customer Care',
      icon: Icons.support_agent,
      message:
          'Call: +260 977 000 000\nEmail: support@unistay.test\nHours: 08:00 - 18:00',
    );
  }
}
