import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordcards/services/db.dart';
import 'package:wordcards/widgets/appbar.dart';
import 'package:wordcards/widgets/word_list.dart';
import 'package:wordcards/widgets/word_search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final _wordStore = WordStore();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyDictAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: () {
            switch (_selectedIndex) {
              case 2:
                return StreamBuilder<QuerySnapshot>(
                  stream: _wordStore.getWords(2),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> words = snapshot.data!.docs
                          .map((doc) => doc['word'] as String)
                          .toList();
                      return WordList(words: words);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              case 1:
                return StreamBuilder<QuerySnapshot>(
                  stream: _wordStore.getWords(1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> words = snapshot.data!.docs
                          .map((doc) => doc['word'] as String)
                          .toList();
                      return WordList(words: words);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return WordSearch();
            }
          }(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Active',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Done',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
