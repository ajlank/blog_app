import 'package:flutter/material.dart';

class NotificationNotifier with ChangeNotifier {
  String _notifRecieverId = '';
  String _notifSenderImage = '';
  String _notifSenderName = '';

  void setNotifRecieverId(String id) {
    _notifRecieverId = id;
    notifyListeners();
  }

  void setNotifierSenderImage(String url) {
    _notifSenderImage = url;
    notifyListeners();
  }

  void setNotifierSenderName(String url) {
    _notifSenderName = url;
    notifyListeners();
  }

  String get notifRecieverId => _notifRecieverId;
  String get notifSenderImage => _notifSenderImage;
  String get notifSenderName => _notifSenderName;
}
