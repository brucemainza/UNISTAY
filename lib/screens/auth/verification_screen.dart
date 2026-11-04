part of '../../main.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    required this.role,
    this.email = 'student@unza.zm',
  });

  final String role;
  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  late final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  Timer? timer;
  int timerSeconds = 28;
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
      timerSeconds = 28;
      errorMessage = '';
    });
    startTimer();
  }

  void verify() {
    final code = controllers.map((controller) => controller.text).join();
    if (code.length != 6) {
      setState(() => errorMessage = 'Enter the 6 digit code');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.role == 'Landlord' ? Routes.landlordHome : Routes.home,
      (route) => false,
    );
  }

  void onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    if (errorMessage.isNotEmpty) setState(() => errorMessage = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Email verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _VerificationBadge(),
              const SizedBox(height: 28),
              const Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: orangePrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We’ve sent a 6-digit code by email. Enter it below to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: grayText, fontSize: 15, height: 1.35),
              ),
              const SizedBox(height: 26),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, color: grayText),
                  hintText: widget.email,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Change email address'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verification code',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                      child: SizedBox(
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
                            hintText: '–',
                            hintStyle: const TextStyle(color: grayText),
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: borderGray),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: orangePrimary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) => onCodeChanged(index, value),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              ErrorText(errorMessage),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: verify,
                child: const Text('Verify'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Didn’t receive a code?',
                textAlign: TextAlign.center,
                style: TextStyle(color: grayText),
              ),
              TextButton.icon(
                onPressed: timerSeconds == 0 ? resendCode : null,
                icon: const Icon(Icons.access_time, size: 18),
                label: Text(
                  timerSeconds == 0
                      ? 'Resend code'
                      : 'Resend code in 00:${timerSeconds.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 22),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, color: orangePrimary, size: 17),
                  SizedBox(width: 6),
                  Text(
                    'Your email stays safe with UniStay.',
                    style: TextStyle(color: grayText, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3E0),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mail_outline,
          color: orangePrimary,
          size: 48,
        ),
      ),
    );
  }
}
