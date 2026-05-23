import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';
import '../service/scan_service.dart';
import '../service/auth_service.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  final Map<String, dynamic> result;
  const ResultScreen({super.key, required this.text, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _meterCtrl;
  late Animation<double> _meterAnim;

  late int _aiScore;
  late int _humanScore;
  late String _mixedSignals;
  late String _verdict;
  late Color _verdictColor;
  late List<Color> _barColors;
  late String _explanation;

  @override
  void initState() {
    super.initState();
    _aiScore = (widget.result['ai_score'] as num).toInt();
    _humanScore = (widget.result['human_score'] as num).toInt();
    _mixedSignals = widget.result['mixed_signals'] ?? 'Low';
    _verdict = widget.result['verdict'] ?? 'Unknown';
    _explanation = widget.result['explanation'] ?? '';

    if (_aiScore >= 70) {
      _verdictColor = AppTheme.neonPink;
      _barColors = [AppTheme.neonPink, AppTheme.neonViolet];
    } else if (_aiScore >= 45) {
      _verdictColor = AppTheme.neonCyan;
      _barColors = [AppTheme.neonCyan, AppTheme.neonViolet];
    } else {
      _verdictColor = AppTheme.neonGreen;
      _barColors = [AppTheme.neonGreen, AppTheme.neonCyan];
    }

    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _meterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _meterAnim = Tween<double>(begin: 0, end: _aiScore / 100).animate(
        CurvedAnimation(parent: _meterCtrl, curve: Curves.easeOutCubic));

    _entryCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300),
        () { if (mounted) _meterCtrl.forward(); });

    // Save to Firestore if logged in
    if (AuthService.currentUser != null) {
      ScanService.saveScan(
        text: widget.text,
        aiScore: _aiScore,
        humanScore: _humanScore,
        verdict: _verdict,
        explanation: _explanation,
        mixedSignals: _mixedSignals,
      );
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _meterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: Column(children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: FadeTransition(
                  opacity: _entryCtrl,
                  child: Column(children: [
                    const SizedBox(height: 18),
                    _buildScoreCard(),
                    const SizedBox(height: 14),
                    _buildBreakdown(),
                    const SizedBox(height: 14),
                    _buildAnalysis(),
                    const SizedBox(height: 18),
                    _buildActions(context),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.neonCyan.withValues(alpha: 0.25), width: 1),
            ),
            child: const Icon(Icons.arrow_back,
                color: AppTheme.neonCyan, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Scan Result',
              style: GoogleFonts.syne(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          Text('Analysis complete',
              style: GoogleFonts.inter(
                  color: AppTheme.textMuted, fontSize: 10)),
        ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _verdictColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _verdictColor.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(children: [
            Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: _verdictColor)),
            const SizedBox(width: 5),
            Text('DONE',
                style: GoogleFonts.syne(
                    color: _verdictColor,
                    fontSize: 9,
                    letterSpacing: 1)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildScoreCard() {
    return GlowCard(
      glowColor: _verdictColor,
      child: Column(children: [
        Text('AI Probability',
            style: GoogleFonts.inter(
                color: AppTheme.textMuted, fontSize: 12)),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _meterAnim,
          builder: (_, __) => RichText(
            text: TextSpan(
              style: GoogleFonts.syne(
                  fontSize: 52, fontWeight: FontWeight.w800),
              children: [
                TextSpan(
                    text: '${(_meterAnim.value * 100).round()}',
                    style: TextStyle(color: _verdictColor)),
                const TextSpan(
                    text: '%',
                    style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 22,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AnimatedBuilder(
            animation: _meterAnim,
            builder: (_, __) => Container(
              height: 10,
              color: AppTheme.bgCardLight,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _meterAnim.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _barColors),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: _barColors.last.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            color: _verdictColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: _verdictColor.withValues(alpha: 0.4), width: 1),
          ),
          child: Text(
            _verdict.toUpperCase(),
            style: GoogleFonts.syne(
                color: _verdictColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5),
          ),
        ),
      ]),
    );
  }

  Widget _buildBreakdown() {
    return GlowCard(
      glowColor: AppTheme.neonViolet,
      child: Column(children: [
        _scoreRow(Icons.smart_toy_outlined, 'AI Score',
            '$_aiScore%', AppTheme.neonPink),
        const SizedBox(height: 10),
        const Divider(color: AppTheme.border, height: 1),
        const SizedBox(height: 10),
        _scoreRow(Icons.person_outline, 'Human Score',
            '$_humanScore%', AppTheme.neonGreen),
        const SizedBox(height: 10),
        const Divider(color: AppTheme.border, height: 1),
        const SizedBox(height: 10),
        _scoreRow(Icons.warning_amber_outlined, 'Mixed Signals',
            _mixedSignals, AppTheme.neonCyan),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            flex: _aiScore,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppTheme.neonPink, AppTheme.neonViolet]),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: _humanScore,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppTheme.neonCyan, AppTheme.neonGreen]),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _scoreRow(
      IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
      const SizedBox(width: 12),
      Text(label,
          style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500)),
      const Spacer(),
      Text(value,
          style: GoogleFonts.syne(
              color: color, fontSize: 14, fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _buildAnalysis() {
    return GlowCard(
      glowColor: AppTheme.neonCyan,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.neonCyan,
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.neonCyan.withValues(alpha: 0.7),
                        blurRadius: 6)
                  ])),
          const SizedBox(width: 8),
          Text('ANALYSIS',
              style: GoogleFonts.syne(
                  color: AppTheme.neonCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 10),
        Text(_explanation,
            style: GoogleFonts.inter(
                color: AppTheme.textPrimary.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.7)),
      ]),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(children: [
      Expanded(
        child: NeonButton(
          label: 'Scan Again',
          icon: Icons.refresh,
          onTap: () => Navigator.pop(context),
          outlined: true,
          gradientColors: const [AppTheme.neonCyan, AppTheme.neonCyan],
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: NeonButton(
          label: 'Copy Result',
          icon: Icons.copy,
          onTap: () {
            Clipboard.setData(ClipboardData(
                text:
                    'AI Probability: $_aiScore%\nVerdict: $_verdict\nHuman Score: $_humanScore%\n\n$_explanation'));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Result copied!',
                    style: GoogleFonts.inter(color: Colors.white)),
                backgroundColor: AppTheme.bgCard,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          gradientColors: const [AppTheme.neonViolet, AppTheme.neonPink],
        ),
      ),
    ]);
  }
}
