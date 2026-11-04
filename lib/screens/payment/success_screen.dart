part of '../../main.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Booking confirmed'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const _IconBadge(icon: Icons.check, color: mintGreen),
          const SizedBox(height: 20),
          const Text('You’re booked, Bruce!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Your December room at Mr Chanda BH is confirmed.', textAlign: TextAlign.center, style: TextStyle(color: grayText)),
          const SizedBox(height: 22),
          const _FlowCard(title: 'Mr Chanda BH', children: [_FlowRow(label: 'Move-in', value: '01 Dec 2026'), _FlowRow(label: 'Move-out', value: '31 Dec 2026'), _FlowRow(label: 'Rental period', value: 'Monthly')]),
          _PrimaryFlowButton(label: 'View receipt', onPressed: () => Navigator.pushNamed(context, Routes.receipt)),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () => Navigator.pushNamed(context, Routes.myAccommodation), child: const Text('My accommodation')),
        ],
      ),
    );
  }
}
