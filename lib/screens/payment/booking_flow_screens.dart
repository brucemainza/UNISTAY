part of '../../main.dart';

class BookingCalendarScreen extends StatefulWidget {
  const BookingCalendarScreen({super.key, required this.room});

  final Room room;

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  DateTime selectedDate = DateTime(2026, 12, 1);
  late DateTime visibleMonth = DateTime(selectedDate.year, selectedDate.month);

  static const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _changeMonth(int offset) {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month + offset);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2026, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: orangePrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      selectedDate = picked;
      visibleMonth = DateTime(picked.year, picked.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leadingDays = firstDay.weekday - DateTime.monday;
    final days = <DateTime?>[
      ...List<DateTime?>.filled(leadingDays, null),
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(visibleMonth.year, visibleMonth.month, day),
    ];

    return Scaffold(
      appBar: const UniAppBar(title: 'Choose move-in date'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const Text(
            'When would you like to move in?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a move-in date for your stay at this room.',
            style: TextStyle(color: grayText),
          ),
          const SizedBox(height: 20),
          _FlowHouseHeader(room: widget.room),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: borderGray),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        '${monthNames[visibleMonth.month - 1]} ${visibleMonth.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final day in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                      Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: grayText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final date = days[index];
                    if (date == null) return const SizedBox.shrink();
                    final selected = date.year == selectedDate.year &&
                        date.month == selectedDate.month &&
                        date.day == selectedDate.day;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDate = date),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: selected ? orangePrimary : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              'Selected: ${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}',
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryFlowButton(
            label: 'Continue',
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.bookingSummary,
              arguments: widget.room,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final total = room.rent + room.deposit;
    return Scaffold(
      appBar: const UniAppBar(title: 'Booking summary'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _FlowHouseHeader(room: room),
          const SizedBox(height: 16),
          _FlowCard(
            title: 'Your stay',
            children: const [
              _FlowRow(label: 'Move-in', value: '01 Dec 2026'),
              _FlowRow(label: 'Move-out', value: '31 Dec 2026'),
              _FlowRow(label: 'Rental period', value: 'Monthly'),
            ],
          ),
          _FlowCard(
            title: 'Price breakdown',
            children: [
              _FlowRow(label: 'Rent · December 2026', value: kwacha(room.rent)),
              _FlowRow(label: 'Deposit', value: kwacha(room.deposit)),
              _FlowRow(
                label: 'Total to pay',
                value: kwacha(total),
                valueColor: mintGreen,
              ),
            ],
          ),
          const _FlowRow(label: 'Guest', value: 'Bruce Mainza'),
          const SizedBox(height: 12),
          const _NoticeCard(
            title: 'Secure your December room',
            message: 'Your booking is confirmed only after payment. The deposit is included in the total.',
          ),
          const SizedBox(height: 24),
          _PrimaryFlowButton(
            label: 'Pay ${kwacha(total)}',
            onPressed: () => _showPaymentSheet(context, total),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, int total) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MobileMoneySheet(total: total),
    );
  }
}

class _MobileMoneySheet extends StatefulWidget {
  const _MobileMoneySheet({required this.total});

  final int total;

  @override
  State<_MobileMoneySheet> createState() => _MobileMoneySheetState();
}

class _MobileMoneySheetState extends State<_MobileMoneySheet> {
  String provider = 'Airtel Money';
  final phoneController = TextEditingController(text: '+260 97 123 4567');

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pay with mobile money',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Text('Mr Chanda BH · Single self-contained', style: TextStyle(color: grayText)),
              const SizedBox(height: 14),
              for (final option in const ['MTN Money', 'Airtel Money', 'Zamtel Kwacha'])
                _ProviderTile(
                  label: option,
                  selected: provider == option,
                  onTap: () => setState(() => provider = option),
                ),
              const SizedBox(height: 10),
              const Text('Mobile money number', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(controller: phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              const Text(
                'Approve the request on your phone. Never share your mobile money PIN with anyone.',
                style: TextStyle(color: grayText, fontSize: 12),
              ),
              const SizedBox(height: 16),
              _PrimaryFlowButton(
                label: 'Pay ${kwacha(widget.total)}',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.processing);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, Routes.success);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Payment processing'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _IconBadge(icon: Icons.phone_android_outlined),
          SizedBox(height: 22),
          Text('Approve on your phone', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          SizedBox(height: 12),
          Text('An Airtel Money request has been sent to +260 97 123 4567.', textAlign: TextAlign.center, style: TextStyle(color: grayText)),
          SizedBox(height: 22),
          Text('K1,450', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, color: orangePrimary, fontWeight: FontWeight.w900)),
          SizedBox(height: 24),
          _FlowCard(title: 'Booking', children: [_FlowRow(label: 'Room', value: 'Mr Chanda BH'), _FlowRow(label: 'Rental period', value: '01–31 Dec 2026')]),
          _NoticeCard(title: 'Please do not close this screen', message: 'Keep UniStay open while we confirm your payment.'),
        ],
      ),
    );
  }
}

class FailedPaymentScreen extends StatelessWidget {
  const FailedPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Payment not completed'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _IconBadge(icon: Icons.error_outline, color: Colors.red),
          const SizedBox(height: 20),
          const Text('Payment not completed', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Text('The Airtel Money request was not approved. No booking has been confirmed.', textAlign: TextAlign.center, style: TextStyle(color: grayText)),
          const SizedBox(height: 24),
          const _FlowCard(title: 'Payment details', children: [_FlowRow(label: 'Payment amount', value: 'K1,450'), _FlowRow(label: 'Payment method', value: 'Airtel Money'), _FlowRow(label: 'Mobile number', value: '+260 97 123 4567')]),
          const SizedBox(height: 24),
          _PrimaryFlowButton(label: 'Retry payment', onPressed: () => Navigator.pushReplacementNamed(context, Routes.processing)),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Change payment method')),
        ],
      ),
    );
  }
}

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Booking details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Wrap(spacing: 8, children: [Chip(label: Text('Confirmed')), Chip(label: Text('Payment received'))]),
          const SizedBox(height: 8),
          const Text('US-261201-0842', style: TextStyle(color: grayText)),
          const SizedBox(height: 16),
          const _FlowHouseHeader(room: Room(type: 'Single self-contained', rent: 1200, deposit: 250, available: true)),
          const _FlowCard(title: 'Your stay', children: [_FlowRow(label: 'Move-in', value: '01 Dec 2026'), _FlowRow(label: 'Move-out', value: '31 Dec 2026'), _FlowRow(label: 'Rental period', value: 'Monthly'), _FlowRow(label: 'Guest', value: 'Bruce Mainza')]),
          const _FlowCard(title: 'Payment details', children: [_FlowRow(label: 'Rent · December 2026', value: 'K1,200'), _FlowRow(label: 'Deposit', value: 'K250'), _FlowRow(label: 'Total paid', value: 'K1,450', valueColor: mintGreen)]),
          Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pushNamed(context, Routes.receipt), child: const Text('View receipt'))), const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: () => Navigator.pushNamed(context, Routes.customerCare), child: const Text('Get help')))]),
        ],
      ),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) => _StateScreen(
        title: 'No connection',
        icon: Icons.wifi_off_outlined,
        heading: 'You’re offline',
        message: 'Check your mobile data or Wi-Fi connection. We’ll help you find your next stay when you’re back online.',
        button: 'Retry',
        onPressed: () => Navigator.pop(context),
      );
}

class ErrorStateScreen extends StatelessWidget {
  const ErrorStateScreen({super.key});

  @override
  Widget build(BuildContext context) => _StateScreen(
        title: 'Something went wrong',
        icon: Icons.error_outline,
        heading: 'Something went wrong',
        message: 'We couldn’t load this page. Please try again in a moment.',
        button: 'Try again',
        onPressed: () => Navigator.pop(context),
      );
}

class _StateScreen extends StatelessWidget {
  const _StateScreen({required this.title, required this.icon, required this.heading, required this.message, required this.button, required this.onPressed});
  final String title;
  final IconData icon;
  final String heading;
  final String message;
  final String button;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: UniAppBar(title: title),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const SizedBox(height: 50),
            _IconBadge(icon: icon),
            const SizedBox(height: 22),
            Text(heading, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: grayText)),
            const SizedBox(height: 24),
            _PrimaryFlowButton(label: button, onPressed: onPressed),
          ]),
        ),
      );
}

class _FlowHouseHeader extends StatelessWidget {
  const _FlowHouseHeader({required this.room});
  final Room room;
  @override
  Widget build(BuildContext context) => Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(houses.first.imageUrl, width: 94, height: 78, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Mr Chanda BH', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), const Text('Single self-contained · Kalingalinga', style: TextStyle(color: grayText)), Text('${kwacha(room.rent)}/m', style: const TextStyle(color: mintGreen, fontWeight: FontWeight.w800, fontSize: 16))])),
      ]);
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: borderGray), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 10), ...children]),
      );
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({required this.label, required this.value, this.valueColor = Colors.black});
  final String label;
  final String value;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: grayText))), Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: valueColor))]));
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.message});
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(message, style: const TextStyle(color: grayText))]));
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, this.color = orangePrimary});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Center(child: Container(width: 88, height: 88, decoration: const BoxDecoration(color: Color(0xFFFFF3E0), shape: BoxShape.circle), child: Icon(icon, size: 44, color: color)));
}

class _PrimaryFlowButton extends StatelessWidget {
  const _PrimaryFlowButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed, child: Text(label)));
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: selected ? const Color(0xFFFFF3E0) : Colors.white, border: Border.all(color: selected ? orangePrimary : borderGray), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? orangePrimary : grayText), const SizedBox(width: 10), Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w400))])));
}
