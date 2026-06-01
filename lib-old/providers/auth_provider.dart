import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _isLoggedIn = LocalStorageService.getLoggedIn();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    _isLoggedIn = true;
    await LocalStorageService.setLoggedIn(true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await LocalStorageService.setLoggedIn(false);
    notifyListeners();
  }
}
