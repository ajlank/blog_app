import 'package:flutter/material.dart';

class ProfileSettingsNotifier with ChangeNotifier {
  String _profileImageurl = '';
  String _userName = '';

  void setUserDetals(String img, String nam) {
    _profileImageurl = img;
    _userName = nam;
    notifyListeners();
  }

  void clearUserDetails() {
    _profileImageurl = '';
    _userName = '';
    notifyListeners();
  }

  String get profileImageUrl => _profileImageurl;
  String get userName => _userName;
}
