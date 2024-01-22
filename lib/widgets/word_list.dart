import 'package:flutter/material.dart';
import 'package:wordcards/models/word.dart';
import 'package:wordcards/screens/word.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.words,
  });

  final List<MyWord> words;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(words[index].word),
            subtitle: Text(
              'Added ${DateTime.now().difference(words[index].createdOn).inDays} days ago',
              style: const TextStyle(fontSize: 11),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordPage(wd: words[index].word),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
