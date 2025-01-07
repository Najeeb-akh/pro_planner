import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String _userName = '';
  String _email = '';
  String _description = '';

  String get userName => _userName;
  String get email => _email;
  String get description => _description;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }
}
