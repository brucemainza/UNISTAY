part of '../../main.dart';

class LandlordPaymentDetailsScreen extends StatelessWidget {
  const LandlordPaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Payment Details',
      icon: Icons.account_balance_wallet_outlined,
      message:
          'Lenco Pay settlement account\nBank: Zanaco\nStatus: Server managed',
    );
  }
}
