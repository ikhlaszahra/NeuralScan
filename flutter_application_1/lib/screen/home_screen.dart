import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';
import '../service/gemini_service.dart';
import '../service/auth_service.dart';
import 'result_screen.dart';
import 'about_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _detectAI = true;
  bool _detectHuman = true;
  bool _detectMixed = true;
  bool _loading = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final result = await GeminiService.analyzeText(_controller.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, b) =>
            ResultScreen(text: _controller.text, result: result),
        transitionsBuilder: (_, a, b, child) => FadeTransition(
          opacity: a,
          child: SlideTransition(
              position:
                  Tween(begin: const Offset(0, 0.05), end: Offset.zero)
                      .animate(a),
              child: child),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: Column(children: [
            _buildAppBar(),
            Expanded(
              child: _loading
                  ? _buildScanning()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(children: [
                        const SizedBox(height: 8),
                        _buildHero(),
                        const SizedBox(height: 18),
                        _buildTextInput(),
                        const SizedBox(height: 14),
                        _buildOptions(),
                        const SizedBox(height: 18),
                        _buildAnalyzeButton(),
                        const SizedBox(height: 14),
                        _buildFooter(),
                        const SizedBox(height: 24),
                      ]),
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildScanning() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
          ),
        ),
        const SizedBox(height: 24),
        Text('ANALYZING CONTENT…',
            style: GoogleFonts.syne(
                color: AppTheme.neonCyan,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2)),
        const SizedBox(height: 8),
        Text('Neural linguistic processing',
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 12)),
      ]),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppTheme.neonViolet, AppTheme.neonCyan]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.neonCyan.withValues(alpha: 0.35),
                  blurRadius: 12)
            ],
          ),
          child: const Icon(Icons.psychology_alt,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('NeuralScan',
              style: GoogleFonts.syne(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5)),
          Text('AI Content Detector',
              style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 10)),
        ]),
        const Spacer(),
        _iconBtn(Icons.history, AppTheme.neonCyan, () {
          if (AuthService.currentUser != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          }
        }),
        const SizedBox(width: 8),
        _iconBtn(Icons.logout, AppTheme.neonPink, () async {
          await AuthService.signOut();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }),
        const SizedBox(width: 8),
        _iconBtn(Icons.info_outline, AppTheme.neonViolet, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AboutScreen()));
        }),
      ]),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildHero() {
    return Column(children: [
      const SizedBox(height: 10),
      ScaleTransition(
        scale: _pulseAnim,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
                colors: [AppTheme.neonViolet, AppTheme.neonCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.neonCyan.withValues(alpha: 0.45),
                  blurRadius: 28,
                  spreadRadius: 4),
            ],
          ),
          child: const Icon(Icons.radar, color: Colors.white, size: 36),
        ),
      ),
      const SizedBox(height: 14),
      Text('Detect AI Writing',
          style: GoogleFonts.syne(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5)),
      const SizedBox(height: 5),
      Text('Neural linguistic pattern analysis',
          style: GoogleFonts.inter(
              color: AppTheme.textMuted, fontSize: 12)),
    ]);
  }

  Widget _buildTextInput() {
    return GlowCard(
      glowColor: AppTheme.neonCyan,
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Row(children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.neonCyan,
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.neonCyan.withValues(alpha: 0.7),
                        blurRadius: 6)
                  ]),
            ),
            const SizedBox(width: 8),
            Text('INPUT TEXT',
                style: GoogleFonts.syne(
                    color: AppTheme.neonCyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5)),
            const Spacer(),
            if (_controller.text.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _controller.clear()),
                child: Text('Clear',
                    style: GoogleFonts.inter(
                        color: AppTheme.textMuted, fontSize: 11)),
              ),
          ]),
        ),
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          maxLines: 7,
          style: GoogleFonts.inter(
              color: AppTheme.textPrimary, fontSize: 13, height: 1.7),
          decoration: InputDecoration(
            hintText: 'Paste or type content to analyze…',
            hintStyle: GoogleFonts.inter(
                color: AppTheme.textMuted.withValues(alpha: 0.4), fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        if (_controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Text(
                '${_controller.text.trim().split(' ').length} words',
                style: GoogleFonts.syne(
                    color: AppTheme.textMuted, fontSize: 10,
                    letterSpacing: 0.5)),
          ),
      ]),
    );
  }

  Widget _buildOptions() {
    return GlowCard(
      glowColor: AppTheme.neonViolet,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(children: [
        _optionRow('Detect AI Content', AppTheme.neonPink, _detectAI,
            (v) => setState(() => _detectAI = v)),
        const Divider(color: AppTheme.border, height: 1),
        _optionRow('Detect Human Content', AppTheme.neonGreen, _detectHuman,
            (v) => setState(() => _detectHuman = v)),
        const Divider(color: AppTheme.border, height: 1),
        _optionRow('Mixed Content', AppTheme.neonCyan, _detectMixed,
            (v) => setState(() => _detectMixed = v)),
      ]),
    );
  }

  Widget _optionRow(
      String label, Color color, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 5,
                    spreadRadius: 1)
              ]),
        ),
        const SizedBox(width: 12),
        Text(label,
            style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const Spacer(),
        NeonSwitch(value: value, color: color, onChanged: onChanged),
      ]),
    );
  }

  Widget _buildAnalyzeButton() {
    final hasText = _controller.text.trim().isNotEmpty;
    return NeonButton(
      label: 'ANALYZE CONTENT',
      icon: Icons.search,
      onTap: hasText ? _analyze : null,
      gradientColors: hasText
          ? [AppTheme.neonViolet, AppTheme.neonCyan]
          : [AppTheme.bgCard, AppTheme.bgCard],
    );
  }

  Widget _buildFooter() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _pill('⚡ Free'),
      const SizedBox(width: 8),
      _pill('🚀 Instant'),
      const SizedBox(width: 8),
      _pill('🔒 Private'),
    ]);
  }

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border, width: 1),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 10)),
      );
}
