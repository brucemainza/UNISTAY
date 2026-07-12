part of '../../main.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Receipt'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          Text('Booking Reference:', style: TextStyle(color: grayText)),
          SizedBox(height: 4),
          Text(
            '#BH-2025-001234',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 20),
          ReceiptPanel(
            title: 'Room Details',
            lines: ['Single Room, Selfcontained', 'K1,200/m'],
          ),
          SizedBox(height: 18),
          InfoRow(icon: Icons.login, text: 'Move-in: 25/1/2025'),
          InfoRow(icon: Icons.logout, text: 'Move-out: 25/1/2025'),
          SizedBox(height: 18),
          ReceiptPanel(
            title: 'Cost Breakdown',
            lines: ['Security: K250', 'Rent: K1,200', 'Total: K1,450'],
          ),
          SizedBox(height: 20),
          Text(
            'Paid via Lenco Pay',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            'Transaction ID: test-verified-001234',
            style: TextStyle(color: grayText),
          ),
        ],
      ),
    );
  }
}
