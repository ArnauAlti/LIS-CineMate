import 'package:flutter/material.dart';

class UserRoleProvider with ChangeNotifier {
  String _userRole = 'Usuario No Registrado';
  String? _userEmail;

  String get userRole => _userRole;
  String? get userEmail => _userEmail;

  void setUserRole(String newRole) {
    _userRole = newRole;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void clearUserData() {
    _userRole = 'Usuario No Registrado';
    _userEmail = null;
    notifyListeners();
  }
}
