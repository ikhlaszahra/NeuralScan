import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';
import '../service/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.signIn(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );
    if (!mounted) return;
    if (err != null) {
      setState(() { _error = err; _loading = false; });
    } else {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  Future<void> _guestLogin() async {
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.signInAnonymously();
    if (!mounted) return;
    if (err != null) {
      setState(() { _error = err; _loading = false; });
    } else {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.neonViolet, AppTheme.neonCyan]),
                  boxShadow: [BoxShadow(
                    color: AppTheme.neonCyan.withValues(alpha: 0.4),
                    blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Icon(Icons.psychology_alt,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Welcome Back',
                style: GoogleFonts.orbitron(
                  color: AppTheme.textPrimary, fontSize: 24,
                  fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text('Sign in to your account',
                style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 14)),
              const SizedBox(height: 40),
              GlowCard(
                glowColor: AppTheme.neonCyan,
                child: Column(children: [
                  _inputField('Email', Icons.email_outlined,
                      _emailCtrl, false),
                  const SizedBox(height: 16),
                  _inputField('Password', Icons.lock_outline,
                      _passCtrl, _obscure,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textMuted, size: 18),
                      )),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.neonPink.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.neonPink.withValues(alpha: 0.3))),
                      child: Text(_error!,
                        style: GoogleFonts.inter(
                          color: AppTheme.neonPink, fontSize: 12)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _loading
                    ? const CircularProgressIndicator(
                        color: AppTheme.neonCyan)
                    : Column(children: [
                        NeonButton(
                          label: 'SIGN IN',
                          icon: Icons.login,
                          onTap: _login,
                        ),
                        const SizedBox(height: 12),
                        NeonButton(
                          label: 'Continue as Guest',
                          icon: Icons.person_outline,
                          onTap: _guestLogin,
                          outlined: true,
                        ),
                      ]),
                ]),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account? ",
                  style: GoogleFonts.inter(
                    color: AppTheme.textMuted, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: Text('Sign Up',
                    style: GoogleFonts.inter(
                      color: AppTheme.neonCyan, fontSize: 13,
                      fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hint, IconData icon,
      TextEditingController ctrl, bool obscure, {Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: AppTheme.textMuted, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.neonCyan, size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
