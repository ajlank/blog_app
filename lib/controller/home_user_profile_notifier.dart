import 'package:flutter/material.dart';

class HomeUserProfileNotifier with ChangeNotifier {
  String _homeUserId = '';

  void setHomeUserId(String id) {
    _homeUserId = id;
    notifyListeners();
  }

  String get homeUserId => _homeUserId;
}
