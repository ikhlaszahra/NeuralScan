import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // Save a scan result
  static Future<void> saveScan({
    required String text,
    required int aiScore,
    required int humanScore,
    required String verdict,
    required String explanation,
    required String mixedSignals,
  }) async {
    if (_uid == null) return;
    try {
      await _db.collection('users').doc(_uid).collection('scans').add({
        'text': text.length > 200 ? '${text.substring(0, 200)}...' : text,
        'aiScore': aiScore,
        'humanScore': humanScore,
        'verdict': verdict,
        'explanation': explanation,
        'mixedSignals': mixedSignals,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Update total scans count
      await _db.collection('users').doc(_uid).update({
        'totalScans': FieldValue.increment(1),
      });
    } catch (e) {
      // ignore
    }
  }

  // Get scan history
  static Stream<QuerySnapshot> getScanHistory() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('scans')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  // Delete a scan
  static Future<void> deleteScan(String scanId) async {
    if (_uid == null) return;
    await _db
        .collection('users')
        .doc(_uid)
        .collection('scans')
        .doc(scanId)
        .delete();
  }

  // Get user stats
  static Future<Map<String, dynamic>> getUserStats() async {
    if (_uid == null) return {};
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      return doc.data() ?? {};
    } catch (e) {
      return {};
    }
  }
}