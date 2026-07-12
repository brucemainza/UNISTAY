part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final viewModel = AuthViewModel();
  late final AnimationController animationController;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    scale = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    animationController.dispose();
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _login() async {
    final result = await viewModel.login(
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted || !result.success || result.route == null) return;
    Navigator.pushNamedAndRemoveUntil(context, result.route!, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          ScaleTransition(
            scale: scale,
            child: const Icon(Icons.person, size: 120, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: orangePrimary,
            ),
          ),
          const SizedBox(height: 20),
          ErrorText(viewModel.errorMessage),
          RoleDropdown(
            selectedRole: viewModel.selectedRole,
            onChanged: viewModel.selectRole,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.loading ? null : _login,
            child: viewModel.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Login'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, Routes.signup),
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}
