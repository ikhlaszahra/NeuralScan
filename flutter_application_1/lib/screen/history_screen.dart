import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../widget/glow_card.dart';
import '../widget/practicle_field.dart';
import '../service/scan_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                          color: AppTheme.neonCyan.withValues(alpha: 0.25))),
                    child: const Icon(Icons.arrow_back,
                        color: AppTheme.neonCyan, size: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Text('Scan History',
                    style: GoogleFonts.syne(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ScanService.getScanHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.neonCyan));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        const Icon(Icons.history,
                            color: AppTheme.textMuted, size: 48),
                        const SizedBox(height: 12),
                        Text('No scans yet',
                            style: GoogleFonts.syne(
                                color: AppTheme.textMuted, fontSize: 14)),
                        Text('Start analyzing content!',
                            style: GoogleFonts.inter(
                                color: AppTheme.textMuted, fontSize: 12)),
                      ]),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      final ai = data['aiScore'] ?? 0;
                      final verdict = data['verdict'] ?? '';
                      final text = data['text'] ?? '';
                      Color color = ai >= 70
                          ? AppTheme.neonPink
                          : ai >= 45
                              ? AppTheme.neonCyan
                              : AppTheme.neonGreen;
                      return Dismissible(
                        key: Key(docs[i].id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) =>
                            ScanService.deleteScan(docs[i].id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppTheme.neonPink),
                        ),
                        child: GlowCard(
                          glowColor: color,
                          padding: const EdgeInsets.all(14),
                          child: Row(children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text('$ai%',
                                  style: GoogleFonts.syne(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                Text(verdict,
                                    style: GoogleFonts.inter(
                                        color: color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 3),
                                Text(text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                        color: AppTheme.textMuted,
                                        fontSize: 11)),
                              ]),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppTheme.textMuted, size: 16),
                          ]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
