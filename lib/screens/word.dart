import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:wordcards/services/db.dart';
import 'package:wordcards/models/word.dart';
import 'package:wordcards/services/storage.dart';
import 'package:wordcards/services/word.dart';
import 'package:wordcards/utils/utils.dart';

class WordPage extends StatefulWidget {
  const WordPage({
    super.key,
    required this.wd,
  });

  final String wd;

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  MyWord? _wordFromStore;

  final _wordStore = WordStore();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Word>(
      future: _getWord(widget.wd),
      builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Word not found')),
            );
          });
          Navigator.pop(context);
          return Container();
        } else {
          Word word = snapshot.data!;
          final phoneticWithAudio = word.phonetics.firstWhere(
            (phonetic) => phonetic.audio != null && phonetic.audio!.isNotEmpty,
            orElse: () => word.phonetics[0], // Default value
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(Utils.capitalizeFirstWord(word.word)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Utils.capitalizeFirstWord(word.word),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (phoneticWithAudio.audio != null &&
                          phoneticWithAudio.audio!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            final player = AudioPlayer();
                            player.play(UrlSource(phoneticWithAudio.audio!));
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FutureBuilder<String>(
                            future: WordImageStore().getImageUrl(word.word),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Container();
                              } else {
                                return Center(
                                  child: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Image.network(snapshot.data!),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Meaning',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...word.meanings.map((meaning) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${meaning.partOfSpeech}:',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ...meaning.definitions.map((definition) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                          '\u2022',
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.55,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                definition.definition,
                                                textAlign: TextAlign.left,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  height: 1.55,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              definition.example != null &&
                                                      definition
                                                          .example!.isNotEmpty
                                                  ? Text(
                                                      "Example: ${definition.example}",
                                                      textAlign: TextAlign.left,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_wordFromStore?.status != 0)
                        FilledButton(
                          onPressed: () {
                            _wordStore.delete(word.word);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: const Text('Delete'),
                        ),
                      const SizedBox(width: 10),
                      _buildAddButtonBasedOnStatus(context, _wordFromStore!),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Word> _getWord(String word) async {
    _wordFromStore = await _wordStore.getWord(word);
    _wordFromStore ??= MyWord(word: word, status: 0, createdOn: DateTime.now());
    return WordService.getWord(word);
  }

  Widget _buildAddButtonBasedOnStatus(BuildContext context, MyWord word) {
    switch (_wordFromStore!.status) {
      case 0:
        return FilledButton.tonal(
          onPressed: () {
            word.status = 1;
            _wordStore.add(word);
            Navigator.pop(context);
          },
          child: const Text('Add to Learn'),
        );
      case 2:
        return FilledButton.tonal(
          onPressed: () {
            word.status = 1;
            _wordStore.update(word);
            Navigator.pop(context);
          },
          child: const Text('Add to Learn'),
        );
      default:
        return FilledButton.tonal(
          onPressed: () {
            word.status = 2;
            _wordStore.update(word);
            Navigator.pop(context);
          },
          child: const Text('Mastered'),
        );
    }
  }
}
