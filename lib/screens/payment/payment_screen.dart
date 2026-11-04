part of '../../main.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.room, this.devMode = false});

  final Room room;
  final bool devMode;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final viewModel = BookingViewModel();
  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCvcController = TextEditingController();
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    phoneController.dispose();
    cardNumberController.dispose();
    cardExpiryController.dispose();
    cardCvcController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
    if (viewModel.error != null) {
      showSnack(context, viewModel.error!);
      viewModel.clearError();
    }
  }

  int get total => widget.room.rent + widget.room.deposit;

  Future<void> _handlePay() async {
    viewModel.setPhone(phoneController.text.trim());

    if (viewModel.session == null) {
      final success = await viewModel.pay(
        amount: total,
        roomType: widget.room.type,
      );
      if (success && mounted) {
        _goToSuccess();
      }
      return;
    }

    final success = await viewModel.verifyPayment();
    if (success && mounted) {
      _goToSuccess();
    }
  }

  Future<void> _retry() async {
    viewModel.setPhone(phoneController.text.trim());
    final success = await viewModel.retryPayment(
      amount: total,
      roomType: widget.room.type,
    );
    if (success && mounted) _goToSuccess();
  }

  void _goToSuccess() {
    Navigator.pushReplacementNamed(context, Routes.success);
  }

  void _nextStep() {
    if (currentStep < 1) setState(() => currentStep++);
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, size: 34, color: Colors.black),
          onPressed: _previousStep,
        ),
        title: const Text(
          'Booking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: _BookingStepper(currentStep: currentStep),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: currentStep == 0
                  ? _DatesStep(
                      key: const ValueKey('dates-step'),
                      room: widget.room,
                      moveInDate: viewModel.moveInDate,
                      onDateSelected: viewModel.setMoveInDate,
                      onNext: _nextStep,
                    )
                  : _PaymentStep(
                      key: const ValueKey('payment-step'),
                      room: widget.room,
                      moveInDate: viewModel.moveInDate,
                      total: total,
                      paymentMethod: viewModel.paymentMethod,
                      operator: viewModel.operator,
                      processing: viewModel.processing,
                      session: viewModel.session,
                      phoneController: phoneController,
                      cardNumberController: cardNumberController,
                      cardExpiryController: cardExpiryController,
                      cardCvcController: cardCvcController,
                      onMethodChanged: viewModel.setPaymentMethod,
                      onOperatorChanged: viewModel.setOperator,
                      onPay: _handlePay,
                      onRetry: _retry,
                    ),
            ),
          ),
            ],
          ),
          if (viewModel.processing) const Positioned.fill(child: OrderLoadingSkeleton()),
        ],
      ),
    );
  }
}

class _BookingStepper extends StatelessWidget {
  const _BookingStepper({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const steps = ['Dates', 'Book', 'Confirm'];
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: i <= currentStep ? orangePrimary : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: i <= currentStep ? orangePrimary : orangePrimary,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i],
                  style: TextStyle(
                    color: i <= currentStep ? orangePrimary : orangePrimary,
                    fontSize: 12,
                    fontWeight: i <= currentStep ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (i < steps.length - 1)
            Expanded(
              flex: 2,
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: i < currentStep ? orangePrimary : orangePrimary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _RoomSummaryCard extends StatelessWidget {
  const _RoomSummaryCard({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: orangePrimary.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD1DC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'image',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.type.toLowerCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kwacha(room.rent),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DatesStep extends StatelessWidget {
  const _DatesStep({
    super.key,
    required this.room,
    required this.moveInDate,
    required this.onDateSelected,
    required this.onNext,
  });

  final Room room;
  final DateTime moveInDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('dates-step'),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
      children: [
        _RoomSummaryCard(room: room),
        const SizedBox(height: 24),
        const Text(
          'Select move-in date',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        _InlineCalendar(
          selectedDate: moveInDate,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(height: 28),
        Center(
          child: SizedBox(
            width: math.min(MediaQuery.sizeOf(context).width * 0.65, 280),
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: orangePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}

class _InlineCalendar extends StatefulWidget {
  const _InlineCalendar({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<_InlineCalendar> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_displayMonth.year, _displayMonth.month, 1).weekday % 7;
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '${_monthName(_displayMonth.month)} ${_displayMonth.year}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('S', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('M', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('T', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('W', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('T', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('F', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('S', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            children: [
              for (var i = 0; i < firstWeekday; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _DayCell(
                  day: day,
                  isSelected: widget.selectedDate.day == day &&
                      widget.selectedDate.month == _displayMonth.month &&
                      widget.selectedDate.year == _displayMonth.year,
                  isToday: today.day == day &&
                      today.month == _displayMonth.month &&
                      today.year == _displayMonth.year,
                  onTap: () => widget.onDateSelected(
                    DateTime(_displayMonth.year, _displayMonth.month, day),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month - 1];
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? orangePrimary : Colors.transparent,
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: orangePrimary, width: 1.5)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected || isToday ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  const _PaymentStep({
    super.key,
    required this.room,
    required this.moveInDate,
    required this.total,
    required this.paymentMethod,
    required this.operator,
    required this.processing,
    required this.session,
    required this.phoneController,
    required this.cardNumberController,
    required this.cardExpiryController,
    required this.cardCvcController,
    required this.onMethodChanged,
    required this.onOperatorChanged,
    required this.onPay,
    required this.onRetry,
  });

  final Room room;
  final DateTime moveInDate;
  final int total;
  final String paymentMethod;
  final String operator;
  final bool processing;
  final PaymentSession? session;
  final TextEditingController phoneController;
  final TextEditingController cardNumberController;
  final TextEditingController cardExpiryController;
  final TextEditingController cardCvcController;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<String> onOperatorChanged;
  final VoidCallback onPay;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('payment-step'),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
      children: [
        _RoomSummaryCard(room: room),
        const SizedBox(height: 18),
        Text(
          'Move in date: ${_formatDate(moveInDate)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFF9E9E9E), thickness: 1),
        const SizedBox(height: 14),
        const Text(
          'Payment Details:',
          style: TextStyle(
            color: orangePrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        _CostLine(label: 'Security Deposit', amount: kwacha(room.deposit)),
        const SizedBox(height: 10),
        _CostLine(label: 'Rent', amount: kwacha(room.rent)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: Colors.black, thickness: 1),
        ),
        _CostLine(
          label: 'Total',
          amount: kwacha(total),
          emphasized: true,
        ),
        const SizedBox(height: 22),
        const Text(
          'Payment method',
          style: TextStyle(
            color: orangePrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MethodButton(
                label: 'Mobile',
                selected: paymentMethod == 'mobile',
                onTap: () => onMethodChanged('mobile'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MethodButton(
                label: 'Card',
                selected: paymentMethod == 'card',
                onTap: () => onMethodChanged('card'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (paymentMethod == 'mobile') ...[
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Mobile Money Operator',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: operator,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: const [
                  DropdownMenuItem(value: 'airtel', child: Text('Airtel Money')),
                  DropdownMenuItem(value: 'mtn', child: Text('MTN Mobile Money')),
                  DropdownMenuItem(value: 'zamtel', child: Text('Zamtel Money')),
                ],
                onChanged: processing ? null : (value) => onOperatorChanged(value ?? 'airtel'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: '+260 XXX XXX XXX',
              prefixIcon: Icon(Icons.phone_android_outlined),
            ),
          ),
        ] else ...[
          TextField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'card number',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cardExpiryController,
                  decoration: const InputDecoration(
                    hintText: '02/24',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: cardCvcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'cvc',
                  ),
                ),
              ),
            ],
          ),
        ],
        if (session != null) ...[
          const SizedBox(height: 14),
          PaymentStatusPanel(session: session!),
        ],
        const SizedBox(height: 28),
        Center(
          child: SizedBox(
            width: math.min(MediaQuery.sizeOf(context).width * 0.55, 240),
            child: ElevatedButton(
              onPressed: processing ? null : onPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: orangePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              child: processing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Processing'),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(session == null ? 'Pay' : 'Check Status'),
            ),
          ),
        ),
        if (session != null && session!.status != 'successful') ...[
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: processing ? null : onRetry,
              child: const Text('Retry Payment'),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _CostLine extends StatelessWidget {
  const _CostLine({
    required this.label,
    required this.amount,
    this.emphasized = false,
  });

  final String label;
  final String amount;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: emphasized ? 16 : 15,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: emphasized ? 17 : 15,
            fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
            color: emphasized ? mintGreen : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _MethodButton extends StatelessWidget {
  const _MethodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? orangePrimary : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: orangePrimary, width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : orangePrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
