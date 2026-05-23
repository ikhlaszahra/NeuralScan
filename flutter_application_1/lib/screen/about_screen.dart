import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.neonViolet.withValues(alpha: 0.25))),
                    child: const Icon(Icons.arrow_back,
                        color: AppTheme.neonViolet, size: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Text('About NeuralScan',
                    style: GoogleFonts.syne(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(children: [
                  const SizedBox(height: 8),
                  _howItWorks(),
                  const SizedBox(height: 14),
                  _features(),
                  const SizedBox(height: 14),
                  _accuracy(),
                  const SizedBox(height: 14),
                  _disclaimer(),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _howItWorks() {
    return GlowCard(
      glowColor: AppTheme.neonViolet,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppTheme.neonViolet,
                  boxShadow: [BoxShadow(
                      color: AppTheme.neonViolet.withValues(alpha: 0.7),
                      blurRadius: 6)])),
          const SizedBox(width: 8),
          Text('HOW IT WORKS',
              style: GoogleFonts.syne(
                  color: AppTheme.neonViolet, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 16),
        _step('01', 'Linguistic Pattern Analysis',
            'Scans for repetitive rhythms & predictable phrasing.',
            AppTheme.neonCyan),
        const SizedBox(height: 12),
        _step('02', 'Gemini AI Probability Modeling',
            'Token distribution measured against human text corpora.',
            AppTheme.neonViolet),
        const SizedBox(height: 12),
        _step('03', 'Signal Classification',
            'Returns AI / Human confidence score with explanation.',
            AppTheme.neonGreen),
      ]),
    );
  }

  Widget _step(String num, String title, String desc, Color color) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1)),
        alignment: Alignment.center,
        child: Text(num,
            style: GoogleFonts.syne(
                color: color, fontSize: 9, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: GoogleFonts.inter(
                color: AppTheme.textPrimary, fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(desc,
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 11, height: 1.5)),
      ])),
    ]);
  }

  Widget _features() {
    final items = [
      ['⚡', 'Instant', 'Millisecond results', AppTheme.neonCyan],
      ['🔒', 'Private', 'No data stored', AppTheme.neonGreen],
      ['🆓', 'Free', 'No login needed', AppTheme.neonViolet],
      ['🌐', 'Multi-lang', 'Major languages', AppTheme.neonPink],
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: items.map((f) => GlowCard(
        glowColor: f[3] as Color,
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(f[0] as String, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(f[1] as String,
              style: GoogleFonts.inter(
                  color: AppTheme.textPrimary, fontSize: 12,
                  fontWeight: FontWeight.w700)),
          Text(f[2] as String,
              style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 10)),
        ]),
      )).toList(),
    );
  }

  Widget _accuracy() {
    return GlowCard(
      glowColor: AppTheme.neonPink,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 5, height: 5,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppTheme.neonPink,
                  boxShadow: [BoxShadow(
                      color: AppTheme.neonPink.withValues(alpha: 0.7),
                      blurRadius: 6)])),
          const SizedBox(width: 8),
          Text('ACCURACY METRICS',
              style: GoogleFonts.syne(color: AppTheme.neonPink,
                  fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 14),
        _accBar('AI Text Detection', 0.89, AppTheme.neonPink),
        const SizedBox(height: 10),
        _accBar('Human Text Detection', 0.84, AppTheme.neonGreen),
        const SizedBox(height: 10),
        _accBar('Mixed Content', 0.72, AppTheme.neonCyan),
      ]),
    );
  }

  Widget _accBar(String label, double val, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label,
            style: GoogleFonts.inter(
                color: AppTheme.textPrimary, fontSize: 12)),
        const Spacer(),
        Text('${(val * 100).round()}%',
            style: GoogleFonts.syne(
                color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(children: [
          Container(height: 5, color: AppTheme.bgCardLight),
          FractionallySizedBox(
            widthFactor: val,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [BoxShadow(
                    color: color.withValues(alpha: 0.5), blurRadius: 5)],
              ),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.neonPink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppTheme.neonPink.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline,
            color: AppTheme.neonPink, size: 15),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Results are indicative, not guaranteed. Use as a reference only — not a definitive determination.',
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 11, height: 1.6),
          ),
        ),
      ]),
    );
  }
}
