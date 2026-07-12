part of '../../main.dart';

class LandlordProfileScreen extends StatelessWidget {
  const LandlordProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Landlord Profile'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 62,
              backgroundColor: lightOrange,
              child: Icon(Icons.person, size: 72, color: orangePrimary),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chanda Properties',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          AccountMenuItem(
            icon: Icons.payments_outlined,
            label: 'Payment Details',
            onTap: () =>
                Navigator.pushNamed(context, Routes.landlordPaymentDetails),
          ),
          const AccountMenuItem(
            icon: Icons.mail_outline,
            label: 'landlord@unistay.test',
          ),
          const AccountMenuItem(
            icon: Icons.phone_outlined,
            label: '0977654321',
          ),
        ],
      ),
    );
  }
}
