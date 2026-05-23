import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_themes.dart';
import '../glow_card.dart';
import '../particle_field.dart';
import 'result_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _detectAI = true;
  bool _detectHuman = true;
  bool _detectMixed = true;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _analyze() {
    if (_controller.text.trim().isEmpty) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, b) => ResultScreen(text: _controller.text),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(height: 8),
                  _buildHeroSection(),
                  const SizedBox(height: 20),
                  _buildTextInput(),
                  const SizedBox(height: 16),
                  _buildOptions(),
                  const SizedBox(height: 20),
                  _buildAnalyzeButton(),
                  const SizedBox(height: 16),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        // Logo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppTheme.neonViolet, AppTheme.neonCyan]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.neonCyan.withAlpha((AppTheme.neonCyan.alpha * 0.4).round()),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: const Icon(Icons.psychology_alt, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('NeuralScan',
              style: GoogleFonts.orbitron(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1)),
          Text('AI Content Detector',
              style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 11)),
        ]),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen())),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.neonViolet.withAlpha((AppTheme.neonViolet.alpha * 0.3).round()), width: 1),
            ),
            child: const Icon(Icons.info_outline,
                color: AppTheme.neonViolet, size: 20),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeroSection() {
    return Column(children: [
      const SizedBox(height: 12),
      ScaleTransition(
        scale: _pulseAnim,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
                colors: [AppTheme.neonViolet, AppTheme.neonCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.neonCyan.withAlpha((AppTheme.neonCyan.alpha * 0.5).round()),
                  blurRadius: 30,
                  spreadRadius: 5),
            ],
          ),
          child: const Icon(Icons.radar, color: Colors.white, size: 40),
        ),
      ),
      const SizedBox(height: 14),
      Text('Detect AI Writing',
          style: GoogleFonts.orbitron(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5)),
      const SizedBox(height: 6),
      Text('Powered by neural linguistic analysis',
          style: GoogleFonts.inter(
              color: AppTheme.textMuted, fontSize: 13)),
    ]);
  }

  Widget _buildTextInput() {
    return GlowCard(
      glowColor: AppTheme.neonCyan,
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(children: [
            const Icon(Icons.edit_document,
                color: AppTheme.neonCyan, size: 16),
            const SizedBox(width: 8),
            Text('Input Text',
                style: GoogleFonts.orbitron(
                    color: AppTheme.neonCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
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
              color: AppTheme.textPrimary, fontSize: 14, height: 1.6),
          decoration: InputDecoration(
            hintText: 'Paste or type content to analyze…',
            hintStyle: GoogleFonts.inter(
                  color: AppTheme.textMuted.withAlpha((AppTheme.textMuted.alpha * 0.5).round()), fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        if (_controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text('${_controller.text.split(' ').length} words',
                style: GoogleFonts.inter(
                    color: AppTheme.textMuted, fontSize: 11)),
          ),
      ]),
    );
  }

  Widget _buildOptions() {
    return GlowCard(
      glowColor: AppTheme.neonViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(children: [
        _optionRow('Detect AI Content', AppTheme.neonPink, _detectAI,
            (v) => setState(() => _detectAI = v)),
        _divider(),
        _optionRow('Detect Human Content', AppTheme.neonGreen, _detectHuman,
            (v) => setState(() => _detectHuman = v)),
        _divider(),
        _optionRow('Mixed Content Analysis', AppTheme.neonCyan, _detectMixed,
            (v) => setState(() => _detectMixed = v)),
      ]),
    );
  }

  Widget _optionRow(
      String label, Color color, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                    color: color.withAlpha((color.alpha * 0.6).round()),
                    blurRadius: 6,
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
        _NeonSwitch(value: value, color: color, onChanged: onChanged),
      ]),
    );
  }

  Widget _divider() => const Divider(
      color: AppTheme.border, height: 1, thickness: 1);

  Widget _buildAnalyzeButton() {
    final hasText = _controller.text.trim().isNotEmpty;
    return NeonButton(
      label: 'ANALYZE CONTENT',
      icon: Icons.search,
      onTap: hasText ? _analyze : null,
      gradientColors: hasText
          ? [AppTheme.neonViolet, AppTheme.neonCyan]
          : [AppTheme.bgCardLight, AppTheme.bgCardLight],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pill('⚡ Free'),
        const SizedBox(width: 8),
        _pill('🚀 Instant'),
        const SizedBox(width: 8),
        _pill('🔒 Private'),
      ],
    );
  }

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border, width: 1),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 11)),
      );
}

// ---- Neon toggle switch ----
class _NeonSwitch extends StatelessWidget {
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _NeonSwitch(
      {required this.value, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? color.withAlpha((color.alpha * 0.25).round()) : AppTheme.bgCardLight,
          border: Border.all(
              color: value ? color : AppTheme.border, width: 1.5),
          boxShadow: value
              ? [
                  BoxShadow(
                      color: color.withAlpha((color.alpha * 0.4).round()),
                      blurRadius: 8,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: value ? 20 : 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? color : AppTheme.textMuted),
            ),
          ),
        ]),
      ),
    );
  }
}
