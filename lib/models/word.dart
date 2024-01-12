class Word {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final String? origin;
  final List<Meanings> meanings;

  Word(
      {required this.word,
      required this.phonetic,
      required this.phonetics,
      this.origin,
      required this.meanings});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      phonetic: json['phonetic'] ?? '',
      phonetics: json['phonetics']
          .map<Phonetic>((phonetic) => Phonetic.fromJson(phonetic))
          .toList(),
      origin: json['origin'] ?? '',
      meanings: json['meanings']
          .map<Meanings>((meaning) => Meanings.fromJson(meaning))
          .toList(),
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({required this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'] ?? '',
    );
  }
}

class Meanings {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meanings({required this.partOfSpeech, required this.definitions});

  factory Meanings.fromJson(Map<String, dynamic> json) {
    return Meanings(
      partOfSpeech: json['partOfSpeech'],
      definitions: json['definitions']
          .map<Definition>((definition) => Definition.fromJson(definition))
          .toList(),
    );
  }
}

class Definition {
  final String definition;
  final String? example;
  final List<String>? synonyms;
  final List<String>? antonyms;

  Definition(
      {required this.definition, this.example, this.synonyms, this.antonyms});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      example: json['example'] ?? '',
      synonyms: json['synonyms'] != null
          ? List<String>.from(json['synonyms'])
          : <String>[],
      antonyms: json['antonyms'] != null
          ? List<String>.from(json['antonyms'])
          : <String>[],
    );
  }
}

class MyWord {
  final String id;
  final String word;

  int status;

  MyWord({required this.word, this.status = 0, this.id = ''});

  factory MyWord.fromJson(Map<String, dynamic> json) {
    return MyWord(
      word: json['word'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'status': status,
      };
}
