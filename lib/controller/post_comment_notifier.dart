import 'package:flutter/material.dart';

class PostCommentNotifier with ChangeNotifier {
  String _docId = '';
  String _commentCollectionId = '';
  bool _isTapped = false;
  String _postId = '';
  String _userId = '';
  int _likeCountForThisUser = 0;

  void setDocId(String id) {
    _docId = id;
    notifyListeners();
  }

  void setCommentCollectedId(String cId) {
    _commentCollectionId = cId;
    notifyListeners();
  }

  void toggleTapped(bool val, String pId) {
    _isTapped = val;
    _postId = pId;
    notifyListeners();
  }

  void setUserIdLikeCount(String id, int count) {
    _userId = id;
    _likeCountForThisUser += count;
    notifyListeners();
  }

  bool get isTapped => _isTapped;
  String get postId => _postId;
  String get docId => _docId;

  String get commentCollectionId => _commentCollectionId;

  String get userId => _userId;
  int get likeCount => _likeCountForThisUser;
}
