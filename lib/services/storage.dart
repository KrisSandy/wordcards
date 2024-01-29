import 'package:firebase_storage/firebase_storage.dart';

class WordImageStore {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> getImageUrl(String word) async {
    // Get a reference to the image file
    final pathRef = _storageRef.child('images/$word.png');

    // Get the download URL
    String downloadUrl = await pathRef.getDownloadURL();

    return downloadUrl;
  }
}
