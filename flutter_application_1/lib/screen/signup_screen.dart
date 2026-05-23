import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';
import '../service/auth_service.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.signUp(
      name: _nameCtrl.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 20),
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.neonViolet.withValues(alpha: 0.3))),
                    child: const Icon(Icons.arrow_back,
                      color: AppTheme.neonViolet, size: 20),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.neonPink, AppTheme.neonViolet]),
                  boxShadow: [BoxShadow(
                    color: AppTheme.neonViolet.withValues(alpha: 0.4),
                    blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Icon(Icons.person_add,
                    color: Colors.white, size: 38),
              ),
              const SizedBox(height: 20),
              Text('Create Account',
                style: GoogleFonts.orbitron(
                  color: AppTheme.textPrimary, fontSize: 22,
                  fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text('Join NeuralScan today — free!',
                style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 13)),
              const SizedBox(height: 30),
              GlowCard(
                glowColor: AppTheme.neonViolet,
                child: Column(children: [
                  _inputField('Full Name', Icons.person_outline, _nameCtrl),
                  const SizedBox(height: 14),
                  _inputField('Email', Icons.email_outlined, _emailCtrl),
                  const SizedBox(height: 14),
                  _inputField('Password', Icons.lock_outline, _passCtrl,
                    obscure: _obscure,
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
                        color: AppTheme.neonViolet)
                    : NeonButton(
                        label: 'CREATE ACCOUNT',
                        icon: Icons.rocket_launch,
                        onTap: _signup,
                        gradientColors: const [
                          AppTheme.neonPink, AppTheme.neonViolet],
                      ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hint, IconData icon,
      TextEditingController ctrl,
      {bool obscure = false, Widget? suffix}) {
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
          prefixIcon: Icon(icon, color: AppTheme.neonViolet, size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
