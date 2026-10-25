  
import 'dart:convert';

import 'package:http/http.dart' as http;

class StudyTip {
  final String text;
  final String author;

  const StudyTip({
    required this.text,
    required this.author,
  });

  factory StudyTip.fromJson(Map<String, dynamic> json) {
    return StudyTip(
      text: json['quote'] as String,
      author: json['author'] as String,
    );
  }
}

class StudyTipsService {
  static final Uri _apiUrl =
      Uri.parse('https://dummyjson.com/quotes/random');

  Future<StudyTip> fetchStudyTip() async {
    final response = await http
        .get(_apiUrl)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Unable to load a study tip.');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic> ||
        decoded['quote'] is! String ||
        decoded['author'] is! String) {
      throw const FormatException('Invalid study tip response.');
    }

    return StudyTip.fromJson(decoded);
  }
}
