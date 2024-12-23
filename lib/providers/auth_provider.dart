import 'dart:convert';
import 'dart:io';

import 'package:booking_hotel_app/models/profile.dart';
import 'package:booking_hotel_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Profile _profile = Profile();
  User _user = User();
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = false;
  String _avatar = '';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  //get
  Profile get profile => _profile;
  User get user => _user;
  bool get isLoading => _isLoading;
  File? get selectedImage => _selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        preferredCameraDevice: source == ImageSource.camera
            ? CameraDevice.front
            : CameraDevice.rear,
      );
      if (image != null) {
        _selectedImage = File(image.path);
        await updateProfile(null, null, null, null, null, null, null, _selectedImage!.path, null);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: ${e.message}");
    } catch (e) {
      debugPrint("Unknown error: $e");
    }
  }
  Future<bool> login(String email, String password) async {
    try {
      bool isSuccess = await _authService.login(email, password);
      if (isSuccess) {
        return true;
      } else
        return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<bool> register(String username, String email, String password,
      String full_name, String phone) async {
    try {
      bool isSuccess = await _authService.register(
          username, email, password, full_name, phone);
      if (isSuccess) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<void> fetchProfile() async {
    _isLoading = true;
    try {
      _isLoading = false;
      _userProfile = await _authService.fetchProfile();
      final resultProfile = _userProfile['profile'];
      if (resultProfile != null) {
        _profile = Profile.fromJson(resultProfile);
      } else {
        _profile = Profile();
      }
      final resultUser = _userProfile['user'];
      if (resultUser != null) {
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
  Future<bool> resetPasswordByEmail(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      bool status = await _authService.resetPassword(email);
      return status;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error provider - reset password: $e ');
      return false;
    }
  }
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = true;
      bool result = await _authService.changePassword(oldPassword, newPassword);
      notifyListeners();
      return result;
    } catch (e) {
      print('Error provider change password: $e');
      return false;
    }
  }
  Future<bool> updateProfile(
    String? fullName,
    String? phone,
    String? gender,
    String? country,
    String? city,
    String? state,
    String? address,
    String? imagePath,
    String? identityImagePath,
  ) async {
    try {
      final response = await _authService.updateProfile(
          fullName: fullName,
          phone: phone,
          gender: gender,
          country: country,
          city: city,
          state: state,
          address: address,
          imagePath: imagePath,
          identityImagePath: identityImagePath
      );
      _profile = response;
      notifyListeners();
      return true;
    } catch (e) {
      print("error: $e");
      return false;
    }
  }
  // Biến lưu lỗi của các trường
  String _errorEmail = "";
  String _errorPhone = "";
  String _errorGender = "";

  // Getter để lấy lỗi
  String get errorEmail => _errorEmail;
  String get errorPhone => _errorPhone;
  String get errorGender => _errorGender;


  void validatePhone(String value) {
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (value.isEmpty) {
      _errorPhone = 'Phone number is required';
    } else if (!phoneRegExp.hasMatch(value)) {
      _errorPhone = 'Phone number must be have 10 digits!';
    } else {
      _errorPhone = "";
    }
    notifyListeners();
  }

}
