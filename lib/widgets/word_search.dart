import 'package:flutter/material.dart';
import 'package:wordcards/screens/word.dart';

class WordSearch extends StatelessWidget {
  WordSearch({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchBar(
              controller: controller,
              hintText: 'Type a word',
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) => navigateToWordPage(context, controller),
            ),
            const SizedBox(height: 16.0),
            FilledButton(
              onPressed: () => navigateToWordPage(context, controller),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(6.0),
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToWordPage(
      BuildContext context, TextEditingController controller) {
    String searchText = controller.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordPage(wd: searchText),
      ),
    );
  }
}
