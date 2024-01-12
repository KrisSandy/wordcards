import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:wordcards/models/word.dart';

final Logger _logger = Logger('WordService');

class WordService {
  static Future<Word> getWord(String word) async {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final wordsRaw = json.decode(response.body);
      Word word = wordsRaw.map((word) => Word.fromJson(word)).toList()[0];
      return word;
    } else {
      print(response.statusCode);
      print(response.body);
      _logger.severe(
          'Failed to fetch word ${response.statusCode}: ${response.body}');
      throw Exception('Failed to fetch word');
    }
  }
}
