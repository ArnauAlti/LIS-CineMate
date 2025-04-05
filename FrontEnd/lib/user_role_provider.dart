import 'package:flutter/material.dart';

class UserRoleProvider with ChangeNotifier {
  String _userRole = 'Usuario No Registrado';

  String get userRole => _userRole;

  void setUserRole(String newRole) {
    _userRole = newRole;
    notifyListeners();
  }
}