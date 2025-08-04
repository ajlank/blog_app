import 'package:flutter/material.dart';

class PostCommentNotifier with ChangeNotifier {
  String _docId = '';
  String _commentCollectionId = '';
  bool _isTapped = false;
  String _postId = '';
  void setDocId(String id) {
    _docId = id;
    notifyListeners();
  }

  void setCommentCollectedId(String cId) {
    _commentCollectionId = cId;
    notifyListeners();
  }

  void toggleTapped(bool val, String pId) {
    print(pId);
    _isTapped = val;
    _postId = pId;
    notifyListeners();
  }

  bool get isTapped => _isTapped;
  String get postId => _postId;
  String get docId => _docId;

  String get commentCollectionId => _commentCollectionId;
}
