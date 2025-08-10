import 'package:flutter/material.dart';

class NotificationNotifier with ChangeNotifier {
  String _notifRecieverId = '';
  String _notifSenderImage = '';
  String _notifSenderName = '';
  bool _isAnyNotification = false;
  String _notificatioRId = '';
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

  void setNotificationRId(String id) {
    _notificatioRId = id;
    notifyListeners();
  }

  void setAnyNotification(bool val) {
    _isAnyNotification = val;
    notifyListeners();
  }

  String get notifRecieverId => _notifRecieverId;
  String get notifSenderImage => _notifSenderImage;
  String get notifSenderName => _notifSenderName;
  bool get isAnyNotification => _isAnyNotification;
  String get notificationRId => _notificatioRId;
}
