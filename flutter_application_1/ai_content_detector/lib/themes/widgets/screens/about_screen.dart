import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_themes.dart';
import '../glow_card.dart';
import '../particle_field.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: Column(children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const SizedBox(height: 12),
                  _buildHowItWorks(),
                  const SizedBox(height: 16),
                  _buildFeatures(),
                  const SizedBox(height: 16),
                  _buildAccuracy(),
                  const SizedBox(height: 24),
                  _buildDisclaimer(),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.neonViolet.withAlpha((AppTheme.neonViolet.alpha * 0.3).round()), width: 1),
            ),
            child: const Icon(Icons.arrow_back,
                color: AppTheme.neonViolet, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Text('About This Tool',
            style: GoogleFonts.orbitron(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _buildHowItWorks() {
    return GlowCard(
      glowColor: AppTheme.neonViolet,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppTheme.neonViolet, AppTheme.neonCyan]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.help_outline,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text('How It Works',
              style: GoogleFonts.orbitron(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 16),
        _stepRow('01', 'Linguistic Pattern Analysis',
            'Scans for repetitive sentence rhythms & predictable phrasing.',
            AppTheme.neonCyan),
        const SizedBox(height: 12),
        _stepRow('02', 'Probability Modeling',
            'Estimates token distribution vs human text corpora.',
            AppTheme.neonViolet),
        const SizedBox(height: 12),
        _stepRow('03', 'Signal Classification',
            'Returns a confidence score with AI / Human breakdown.',
            AppTheme.neonGreen),
      ]),
    );
  }

  Widget _stepRow(
      String num, String title, String desc, Color color) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withAlpha((color.alpha * 0.15).round()),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha((color.alpha * 0.4).round()), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(num,
            style: GoogleFonts.orbitron(
                color: color, fontSize: 9, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(desc,
              style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 12, height: 1.5)),
        ]),
      ),
    ]);
  }

  Widget _buildFeatures() {
    final features = [
      ['⚡', 'Instant Analysis', 'Results in milliseconds', AppTheme.neonCyan],
      ['🔒', 'Privacy First', 'No data stored or sent', AppTheme.neonGreen],
      ['🆓', 'Completely Free', 'No login required', AppTheme.neonViolet],
      ['🌐', 'Multi-language', 'Supports major languages', AppTheme.neonPink],
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: features.map((f) => GlowCard(
        glowColor: f[3] as Color,
        padding: const EdgeInsets.all(14),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(f[0] as String, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              Text(f[1] as String,
                  style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              Text(f[2] as String,
                  style: GoogleFonts.inter(
                      color: AppTheme.textMuted, fontSize: 11)),
            ]),
      )).toList(),
    );
  }

  Widget _buildAccuracy() {
    return GlowCard(
      glowColor: AppTheme.neonPink,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.bar_chart, color: AppTheme.neonPink, size: 18),
          const SizedBox(width: 8),
          Text('Accuracy Metrics',
              style: GoogleFonts.orbitron(
                  color: AppTheme.neonPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ]),
        const SizedBox(height: 14),
        _accuracyBar('AI Text Detection', 0.89, AppTheme.neonPink),
        const SizedBox(height: 10),
        _accuracyBar('Human Text Detection', 0.84, AppTheme.neonGreen),
        const SizedBox(height: 10),
        _accuracyBar('Mixed Content', 0.72, AppTheme.neonCyan),
      ]),
    );
  }

  Widget _accuracyBar(String label, double value, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label,
            style: GoogleFonts.inter(
                color: AppTheme.textPrimary, fontSize: 12)),
        const Spacer(),
        Text('${(value * 100).round()}%',
            style: GoogleFonts.orbitron(
                color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(children: [
          Container(
              height: 6, color: AppTheme.bgCardLight),
          FractionallySizedBox(
            widthFactor: value,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      color: color.withAlpha((color.alpha * 0.5).round()),
                      blurRadius: 6,
                      offset: const Offset(0, 1))
                ],
              ),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.neonPink.withAlpha((AppTheme.neonPink.alpha * 0.05).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.neonPink.withAlpha((AppTheme.neonPink.alpha * 0.2).round()), width: 1),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline,
            color: AppTheme.neonPink, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Results are indicative, not guaranteed. This tool uses statistical models and cannot replace human judgment. Results should be used as a reference only.',
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 12, height: 1.6),
          ),
        ),
      ]),
    );
  }
}
