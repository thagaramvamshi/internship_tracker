
import 'dart:convert';

import 'package:http/http.dart' as http;

class CareerTip {
  final String text;
  final String author;

  const CareerTip({
    required this.text,
    required this.author,
  });

  factory CareerTip.fromJson(Map<String, dynamic> json) {
    return CareerTip(
      text: json['quote'] as String,
      author: json['author'] as String,
    );
  }
}

class TipsService {
  static final Uri _url =
      Uri.parse('https://dummyjson.com/quotes/random');

  Future<CareerTip> fetchTip() async {
    final response = await http
        .get(_url)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load a tip. Please try again.',
      );
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic> ||
        data['quote'] is! String ||
        data['author'] is! String) {
      throw const FormatException(
        'Invalid response from the tips API.',
      );
    }

    return CareerTip.fromJson(data);
  }
}
