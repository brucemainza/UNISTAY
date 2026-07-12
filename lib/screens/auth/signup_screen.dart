part of '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final viewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _continue() async {
    final valid = await viewModel.validateRegistration(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (!mounted || !valid) return;
    Navigator.pushNamed(
      context,
      Routes.verification,
      arguments: viewModel.selectedRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.person, size: 100, color: Colors.black),
          const SizedBox(height: 12),
          const Text(
            'Sign up',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: orangePrimary,
            ),
          ),
          const SizedBox(height: 18),
          ErrorText(viewModel.errorMessage),
          RoleDropdown(
            selectedRole: viewModel.selectedRole,
            onChanged: viewModel.selectRole,
          ),
          const SizedBox(height: 12),
          SignUpField(
            controller: fullNameController,
            label: 'Full Name',
            icon: Icons.badge_outlined,
          ),
          SignUpField(
            controller: phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SignUpField(
            controller: emailController,
            label: 'Email',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          SignUpField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          SignUpField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_reset,
            obscureText: true,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: viewModel.loading ? null : _continue,
            child: viewModel.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Sign Up'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Already have account? Login'),
          ),
        ],
      ),
    );
  }
}
