import 'package:flutter/material.dart';
import 'package:wordcards/models/word.dart';
import 'package:wordcards/screens/word.dart';
import 'package:wordcards/utils/utils.dart';

class WordList extends StatefulWidget {
  const WordList({
    super.key,
    required this.words,
  });

  final List<MyWord> words;

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.words.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              Utils.capitalizeFirstWord(widget.words[index].word),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            subtitle: Text(
              'Added ${DateTime.now().difference(widget.words[index].createdOn).inDays} days ago',
              style: const TextStyle(fontSize: 11),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordPage(wd: widget.words[index].word),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
