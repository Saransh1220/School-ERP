import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import 'auth_providers.dart';

enum LoginMode { phone, email, otp }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  LoginMode _mode = LoginMode.phone;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _verificationId;
  String? _errorMsg;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    
    // Simple validation (assume user adds +CountryCode or we add it)
    // For MVP, user must enter full E.164
    if (!phone.startsWith('+')) {
      setState(() => _errorMsg = "Please enter phone with country code (e.g. +91...)");
      return;
    }

    setState(() => _errorMsg = null);
    ref.read(authControllerProvider.notifier).sendOtp(
      phoneNumber: phone,
      onCodeSent: (verId, resendToken) {
        setState(() {
          _verificationId = verId;
          _mode = LoginMode.otp;
        });
      },
      onVerificationFailed: (e) {
        setState(() => _errorMsg = e.toString().replaceAll("Exception: ", ""));
      },
      onCodeAutoRetrievalTimeout: (verId) {
        _verificationId = verId;
      },
    );
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _errorMsg = "Enter valid 6-digit OTP");
      return;
    }
    if (_verificationId == null) return;

    setState(() => _errorMsg = null);
    ref.read(authControllerProvider.notifier).verifyOtp(
      verificationId: _verificationId!,
      smsCode: otp,
    );
  }

  void _handleEmailLogin() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    if (email.isEmpty || pass.isEmpty) return;

    ref.read(authControllerProvider.notifier).loginWithEmail(email, pass);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;
    
    // Listen for global errors from controller
    ref.listen(authControllerProvider, (prev, next) {
      if (next.hasError) {
        setState(() => _errorMsg = next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.school, size: 80, color: DesignSystem.parentTeal),
               const SizedBox(height: 16),
               Text("KinderGuard", style: DesignSystem.fontHeader),
               const SizedBox(height: 32),
               if (_errorMsg != null) ...[
                 Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                   child: Text(_errorMsg!, style: const TextStyle(color: Colors.red)),
                 ),
                 const SizedBox(height: 16),
               ],
               
               if (_mode == LoginMode.phone) ...[
                 _buildPhoneInput(isLoading),
                 const SizedBox(height: 16),
                 TextButton(
                   onPressed: () => setState(() => _mode = LoginMode.email),
                   child: const Text("Admin/Teacher? Login with Email"),
                 )
               ] else if (_mode == LoginMode.otp) ... [
                  _buildOtpInput(isLoading),
                  const SizedBox(height: 16),
                  TextButton(
                   onPressed: () => setState(() => _mode = LoginMode.phone),
                   child: const Text("Change Number"),
                 )
               ] else ...[
                 _buildEmailInput(isLoading),
                 const SizedBox(height: 16),
                 TextButton(
                   onPressed: () => setState(() => _mode = LoginMode.phone),
                   child: const Text("Go back to Parent Login"),
                 )
               ]
             ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Parent Login", style: DesignSystem.fontTitle, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: "Phone Number (+CountryCode)",
            hintText: "+15550109999",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          enabled: !isLoading,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _handleSendOtp,
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 16),
             backgroundColor: DesignSystem.parentTeal,
             foregroundColor: Colors.white,
          ),
          child: isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Get OTP"),
        )
      ],
    );
  }

  Widget _buildOtpInput(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Verify OTP", style: DesignSystem.fontTitle, textAlign: TextAlign.center),
        Text("Sent to ${_phoneController.text}", textAlign: TextAlign.center, style: DesignSystem.fontSmall),
        const SizedBox(height: 24),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          decoration: const InputDecoration(
            hintText: "000000",
            border: OutlineInputBorder(),
            counterText: "",
          ),
          enabled: !isLoading,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _handleVerifyOtp,
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 16),
             backgroundColor: DesignSystem.parentTeal,
             foregroundColor: Colors.white,
          ),
          child: isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Verify"),
        )
      ],
    );
  }

  Widget _buildEmailInput(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Staff Login", style: DesignSystem.fontTitle, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          enabled: !isLoading,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          enabled: !isLoading,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _handleEmailLogin,
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 16),
             backgroundColor: DesignSystem.parentOrange,
             foregroundColor: Colors.white,
          ),
          child: isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Login"),
        )
      ],
    );
  }
}
