import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // Replace YOUR_GEMINI_API_KEY with your actual key
  static const String _apiKey =  "YOUR_GEMINI_API_KEY_HERE";
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<Map<String, dynamic>> analyzeText(String text) async {
    try {
      final prompt = '''
You are an expert AI content detector. Analyze the provided text to determine if it was written by AI or a human.

Base your analysis on:
- Linguistic patterns: Repetitive structures, unnatural phrasing, overused transitions
- Content coherence: Logical flow, depth of ideas, originality
- Stylistic elements: Vocabulary variety, sentence complexity, emotional tone
- Statistical likelihood: Common AI generation artifacts

Provide scores where ai_score + human_score = 100.

Return ONLY a valid JSON object with these exact fields:
{
  "ai_score": <integer 0-100>,
  "human_score": <integer 0-100>,
  "mixed_signals": "<Low|Medium|High>",
  "verdict": "<AI-Generated|Likely Mixed|Human Written>",
  "explanation": "<2-3 sentence detailed explanation>"
}

Do not include any markdown, code blocks, or extra text. Just the JSON.

Text to analyze:
"""$text"""
''';

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 512,
          }
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          
          if (data.containsKey('error')) {
            throw Exception('API Error: ${data['error']['message']}');
          }
          
          if (!data.containsKey('candidates') || data['candidates'].isEmpty) {
            throw Exception('No candidates in response');
          }
          
          final rawText =
              data['candidates'][0]['content']['parts'][0]['text'] as String;

          // Clean JSON from markdown if present
          final cleaned = rawText
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .replaceAll('"', '"')
              .replaceAll('"', '"')
              .trim();

          final result = jsonDecode(cleaned);
          
          // Validate response has required fields
          if (!result.containsKey('ai_score') || 
              !result.containsKey('human_score') ||
              !result.containsKey('verdict') ||
              !result.containsKey('explanation')) {
            throw Exception('Invalid response format');
          }
          
          print('✓ API Response Success');
          return result;
        } catch (parseError) {
          print('✗ JSON Parse Error: $parseError');
          throw Exception('Failed to parse API response: $parseError');
        }
      } else {
        print('✗ API Error: Status ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('✗ Analysis Failed: $e');
      // Return readable error message
      return {
        'ai_score': 0,
        'human_score': 0,
        'mixed_signals': 'Unknown',
        'verdict': 'Error',
        'explanation':
            'Analysis failed. Please ensure you have an internet connection and try again.',
      };
    }
  }
}
