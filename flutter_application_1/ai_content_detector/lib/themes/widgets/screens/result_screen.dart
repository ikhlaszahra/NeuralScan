import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../app_themes.dart';
import '../glow_card.dart';
import '../particle_field.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Mock analysis - in real app, this would call an API
    final aiProbability = _calculateAIProbability(text);

    return Scaffold(
      body: ParticleField(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildResultCard(aiProbability),
                      const SizedBox(height: 20),
                      _buildTextPreview(),
                      const SizedBox(height: 20),
                      _buildConfidenceMeter(aiProbability),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neonCyan.withAlpha((AppTheme.neonCyan.alpha * 0.3).round())),
              ),
              child: const Icon(Icons.arrow_back, color: AppTheme.neonCyan),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Analysis Result',
            style: GoogleFonts.orbitron(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(double aiProbability) {
    final isAI = aiProbability > 0.5;
    return GlowCard(
      glowColor: isAI ? AppTheme.neonPink : AppTheme.neonGreen,
      child: Column(
        children: [
          Icon(
            isAI ? Icons.warning : Icons.check_circle,
            size: 48,
            color: isAI ? AppTheme.neonPink : AppTheme.neonGreen,
          ),
          const SizedBox(height: 16),
          Text(
            isAI ? 'AI-Generated Content' : 'Human-Written Content',
            style: GoogleFonts.orbitron(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confidence: ${(aiProbability * 100).toInt()}%',
            style: GoogleFonts.roboto(
              color: AppTheme.textMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPreview() {
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyzed Text',
            style: GoogleFonts.orbitron(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text.length > 200 ? '${text.substring(0, 200)}...' : text,
            style: GoogleFonts.roboto(
              color: AppTheme.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceMeter(double aiProbability) {
    return GlowCard(
      child: Column(
        children: [
          Text(
            'AI Detection Confidence',
            style: GoogleFonts.orbitron(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: aiProbability,
            center: Text(
              '${(aiProbability * 100).toInt()}%',
              style: GoogleFonts.orbitron(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: aiProbability > 0.5 ? AppTheme.neonPink : AppTheme.neonGreen,
            backgroundColor: AppTheme.bgCardLight,
          ),
        ],
      ),
    );
  }

  double _calculateAIProbability(String text) {
    // Simple mock logic - in real app, use ML model
    final aiKeywords = ['generated', 'ai', 'artificial', 'neural', 'machine'];
    final words = text.toLowerCase().split(' ');
    final aiWordCount = aiKeywords.where((keyword) => words.contains(keyword)).length;
    return (aiWordCount / words.length).clamp(0.0, 1.0);
  }
}