import 'package:flutter/material.dart';

class HomeUserProfileNotifier with ChangeNotifier {
  String _homeUserId = '';
  String _homeUserName = '';
  String notificatioRId = '';
  String _allMessageSpecificUserId = '';
  String _currentProfileUserId = '';
  String _currentUserName = '';
  String _senderName = '';
  String _senderId = '';

  void setHomeUserId(String id) {
    _homeUserId = id;
    notifyListeners();
  }

  void setSenderName(String name) {
    _senderName = name;
    notifyListeners();
  }

  void setSenderId(String id) {
    _senderId = id;
    notifyListeners();
  }

  void setCurrentUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }

  void setcurrentProfileUser(String id) {
    _currentProfileUserId = id;
    notifyListeners();
  }

  void setHomeUserName(String name) {
    _homeUserName = name;
    notifyListeners();
  }

  void setAllMessageSpecificUserId(String id) {
    _allMessageSpecificUserId = id;
    notifyListeners();
  }

  String get homeUserId => _homeUserId;

  String get homeUserName => _homeUserName;

  String get allMessageSpecificUserId => _allMessageSpecificUserId;

  String get currentProfileUserId => _currentProfileUserId;
  String get currentUserName => _currentUserName;
  String get senderName => _senderName;
  String get senderId => _senderId;
}
