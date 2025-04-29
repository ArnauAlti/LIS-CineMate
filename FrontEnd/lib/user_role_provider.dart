import 'package:flutter/material.dart';

class UserRoleProvider with ChangeNotifier {
  String _userRole = 'Usuario No Registrado';
  String? _userEmail;
  Map<String, dynamic>? _user;

  String get userRole => _userRole;
  String? get userEmail => _userEmail;
  Map<String, dynamic>? get getUser => _user;


  void setUserRole(String newRole) {
    _userRole = newRole;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void setUser(Map<String, dynamic> user) {
    _user = user;
    notifyListeners();
  }

  void clearUserData() {
    _userRole = 'Usuario No Registrado';
    _userEmail = null;
    _user = null;
    notifyListeners();
  }
}
