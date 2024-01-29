import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordcards/models/word.dart';
import 'package:wordcards/services/db.dart';
import 'package:wordcards/widgets/word_grid.dart';
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
      appBar: AppBar(
        title: Text(getAppBarTitle(_selectedIndex)),
      ),
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
                      List<MyWord> words = snapshot.data!.docs
                          .map((doc) => doc.data() as MyWord)
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
                      List<MyWord> words = snapshot.data!.docs
                          .map((doc) => doc.data() as MyWord)
                          .toList();
                      return WordGrid(words: words);
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
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Mastered',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  String getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Search';
      case 1:
        return 'Learn';
      case 2:
        return 'Mastered';
      default:
        return '';
    }
  }
}
