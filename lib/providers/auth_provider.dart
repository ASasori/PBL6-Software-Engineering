import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../services/api_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      bool isSuccess = await _authService.login(email, password);
      if (isSuccess) {
        return true;
      } else return false;
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<bool> register(String username, String email, String password, String full_name, String phone) async {
    try {
      bool isSuccess = await _authService.register(username, email, password, full_name, phone);
      if (isSuccess) {
        return true;
      } else return false;
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
