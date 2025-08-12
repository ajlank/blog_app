import 'package:flutter/material.dart';

class AuthErrorNotifier with ChangeNotifier {
  String _emailError = '';
  String _passwordError = '';

  void setEmailError(String e) {
    _emailError = e;
    notifyListeners();
  }

  void setPasswordError(String e) {
    _passwordError = e;
    notifyListeners();
  }

  String get emailEmailError => _emailError;
  String get passwordError => _passwordError;
}
