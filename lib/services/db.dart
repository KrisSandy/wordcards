import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordcards/models/word.dart';

class WordStore {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _wordsRef;

  WordStore() {
    _wordsRef = _firestore.collection('words').withConverter<MyWord>(
        fromFirestore: (snapshots, _) => MyWord.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (word, _) => word.toJson());
  }

  Future<void> add(MyWord word) async {
    await _wordsRef.add(word);
  }

  Future<void> update(MyWord word) async {
    await _wordsRef.doc(word.id).update(word.toJson());
  }

  Stream<QuerySnapshot> getWords(int status) {
    return _wordsRef.where('status', isEqualTo: status).snapshots();
  }

  Future<void> delete(String docId) async {
    await _wordsRef.doc(docId).delete();
  }

  Future<MyWord> getWord(String word) async {
    final snapshot = await _wordsRef.where('word', isEqualTo: word).get();
    if (snapshot.docs.isEmpty) {
      return MyWord(word: word);
    }
    return MyWord(
      word: snapshot.docs.first['word'],
      status: snapshot.docs.first['status'],
      id: snapshot.docs.first.id,
    );
  }
}
