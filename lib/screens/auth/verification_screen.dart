part of '../../main.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.role});

  final String role;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final controllers = List.generate(5, (_) => TextEditingController());
  final focusNodes = List.generate(5, (_) => FocusNode());
  Timer? timer;
  int timerSeconds = 50;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (activeTimer) {
      if (!mounted) return;
      if (timerSeconds == 0) {
        activeTimer.cancel();
      } else {
        setState(() => timerSeconds--);
      }
    });
  }

  void resendCode() {
    setState(() {
      timerSeconds = 50;
      errorMessage = '';
    });
    startTimer();
  }

  void verify() {
    final code = controllers.map((controller) => controller.text).join();
    if (code.length != 5) {
      setState(() => errorMessage = 'Enter the 5 digit code');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.role == 'Landlord' ? Routes.landlordHome : Routes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 44),
          const Text(
            'Verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: orangePrimary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return SizedBox(
                width: 56,
                height: 60,
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < focusNodes.length - 1) {
                      focusNodes[index + 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          const Text(
            'Please enter the code sent to your email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: grayText),
          ),
          const SizedBox(height: 20),
          if (errorMessage.isNotEmpty) ErrorText(errorMessage),
          Text(
            timerSeconds == 0
                ? 'Did not get code?'
                : 'Resend in: ${timerSeconds}s',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: grayText),
          ),
          TextButton(
            onPressed: timerSeconds == 0 ? resendCode : null,
            child: const Text('Resend'),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: verify,
                child: const Text('Verify'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
