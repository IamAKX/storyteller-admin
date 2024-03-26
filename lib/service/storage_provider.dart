import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:universal_html/html.dart';

class StorageProvider extends ChangeNotifier {
  static StorageProvider instance = StorageProvider();
  late FirebaseStorage _storage;

  StorageProvider() {
    _storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile(
      String folderName, String name, Uint8List file) async {
    String path = '$folderName/$name';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putData(file);
    await uploadTask.whenComplete(() {
      ref.getDownloadURL();
    });
    return ref.getDownloadURL();
  }
}
