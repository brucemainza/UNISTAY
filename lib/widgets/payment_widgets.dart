part of '../main.dart';

class PaymentStatusPanel extends StatelessWidget {
  const PaymentStatusPanel({super.key, required this.session});

  final PaymentSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightOrange.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: orangePrimary.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Server payment status: ${session.status}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text('Reference: ${session.reference}'),
          if (session.lencoReference != null)
            Text('Lenco reference: ${session.lencoReference}'),
          if (session.status == 'pay-offline')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Authorize the mobile-money prompt on your phone, then check the status.',
                style: TextStyle(color: grayText),
              ),
            ),
        ],
      ),
    );
  }
}
