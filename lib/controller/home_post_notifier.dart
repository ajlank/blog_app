import 'package:flutter/material.dart';

class HomePostNotifier with ChangeNotifier {
  String _docId = '';
  String _postImg = '';
  String _postText = '';
  String _userName = '';
  String _userImgUrl = '';
  void setDocId(String id) {
    _docId = id;
    notifyListeners();
  }

  void setPostImage(String url) {
    _postImg = url;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUserImgUrl(String url) {
    _userImgUrl = url;
    notifyListeners();
  }

  void setPostTex(String url) {
    _postText = url;
    notifyListeners();
  }

  String get docId => _docId;

  String get postImg => _postImg;
  String get postText => _postText;
  String get userName => _userName;
  String get userImgUrl => _userImgUrl;
}
