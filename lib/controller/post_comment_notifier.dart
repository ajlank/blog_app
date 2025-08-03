import 'package:flutter/material.dart';

class PostCommentNotifier with ChangeNotifier {
  String _docId = '';

  void setDocId(String id) {
    _docId = id;
    print(docId);
    notifyListeners();
  }

  String get docId => _docId;
}
