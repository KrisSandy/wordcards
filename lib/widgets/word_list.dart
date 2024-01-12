import 'package:flutter/material.dart';
import 'package:wordcards/screens/word.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.words,
  });

  final List words;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: words.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(words[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordPage(wd: words[index]),
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
