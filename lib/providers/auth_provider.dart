import 'package:booking_hotel_app/models/profile.dart';
import 'package:booking_hotel_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {

  final AuthService _authService = AuthService();

  Profile _profile = Profile();
  User _user = User();
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = false;

  Profile get profile => _profile;
  User get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    try {
      bool isSuccess = await _authService.login(email, password);
      if (isSuccess) {
        return true;
      } else return false;
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
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<void> fetchProfile () async {
    _isLoading = true;
    try {
      _isLoading = false;
      _userProfile = await _authService.fetchProfile();
      final resultProfile = _userProfile['profile'];
      if (resultProfile != null){
        _profile = Profile.fromJson(resultProfile);
      } else {
        _profile = Profile();
      }
      final resultUser = _userProfile['user'];
      if (resultUser != null){
        _user = User.fromJson(resultUser);
      } else {
        _user = User();
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _profile = Profile();
      _user = User();
      notifyListeners();
      print('Error: $e');
    }
  }
}
