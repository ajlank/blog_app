import 'package:flutter/material.dart';

class HomeUserProfileNotifier with ChangeNotifier {
  String _homeUserId = '';
  String _homeUserName = '';
  void setHomeUserId(String id) {
    _homeUserId = id;
    notifyListeners();
  }

  void setHomeUserName(String name) {
    _homeUserName = name;
    notifyListeners();
  }

  String get homeUserId => _homeUserId;

  String get homeUserName => _homeUserName;
}
