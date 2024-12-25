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
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  //get
  Profile get profile => _profile;
  User get user => _user;
  bool get isLoading => _isLoading;
  bool get  isPasswordVisible => _isPasswordVisible;
  bool get  isConfirmPasswordVisible => _isConfirmPasswordVisible;
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
  Future<bool> register(String email, String password,
      String username, String phone) async {
    try {
      bool isSuccess = await _authService.register(email, password, username, phone);
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


  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'fullName': TextEditingController(),
    'phone': TextEditingController(),
    'username': TextEditingController(),
    'gender': TextEditingController(),
    'country': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'address': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'newPassword': TextEditingController(),
    'confirmNewPassword': TextEditingController(),
  };

  final Map<String, String?> errors = {
    'email': null,
    'fullName': null,
    'phone': null,
    'username': null,
    'gender': null,
    'password': null,
    'confirmPassword': null,
    'newPassword': null,
    'confirmNewPassword': null,
  };

  String? getError(String field) => errors[field];

  void resetError() {
    errors.updateAll((key, value) => null);
    notifyListeners();
  }

  void resetController() {
    controllers.updateAll((key, value) => TextEditingController());
    notifyListeners();
  }
  void resetPasswordVisible() {
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    notifyListeners();
  }

  void validateField(String field) {
    final value = controllers[field]?.text.trim() ?? '';
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final phoneRegExp = RegExp(r'^\d{10}$');

    switch (field) {
      case 'email':
        if (value.isEmpty) {
          errors[field] = 'Email is required';
        } else if (!emailRegExp.hasMatch(value)) {
          errors[field] = 'Invalid email address!';
        } else {
          errors[field] = null;
        }
        break;

      case 'phone':
        if (value.isEmpty) {
          errors[field] = 'Phone number is required';
        } else if (!phoneRegExp.hasMatch(value)) {
          errors[field] = 'Phone number must be 10 digits!';
        } else {
          errors[field] = null;
        }
        break;

      case 'fullName':
        if (value.isEmpty) {
          errors[field] = 'Full name is required';
        } else {
          errors[field] = null;
        }
        break;

      case 'username':
        if (value.isEmpty) {
          errors[field] = 'Username is required';
        } else {
          errors[field] = null;
        }
        break;

      case 'password':
        if (value.isEmpty) {
          errors[field] = 'Password is required';
        } else if (value.length < 8) {
          errors[field] = 'Password must be at least 8 characters!';
        } else {
          errors[field] = null;
        }
        break;

      case 'confirmPassword':
        if (value.isEmpty) {
          errors[field] = 'Confirm password is required';
        } else if (value != controllers['password']?.text.trim()) {
          errors[field] = 'Passwords do not match!';
        } else {
          errors[field] = null;
        }
        break;

      case 'newPassword':
        if (value.isEmpty) {
          errors[field] = 'New password is required';
        } else if (value.length < 8) {
          errors[field] = 'New password must be at least 8 characters!';
        } else {
          errors[field] = null;
        }
        break;

      case 'confirmNewPassword':
        if (value.isEmpty) {
          errors[field] = 'Confirm new password is required';
        } else if (value != controllers['newPassword']?.text.trim()) {
          errors[field] = 'New passwords do not match!';
        } else {
          errors[field] = null;
        }
        break;

      default:
        throw Exception('Unknown field: $field');
    }

    notifyListeners();
  }

  bool validateAll(List<String> fields) {
    bool isValid = true;

    for (var field in fields) {
      validateField(field);
      if (errors[field] != null) {
        isValid = false;
      }
    }

    return isValid;
  }

  bool validateLogin() {
    return validateAll(['email', 'password']);
  }

  bool validateRegister() {
    return validateAll(['email', 'password', 'username', 'phone']);
  }

  bool validateForgotPassword() {
    return validateAll(['email']);
  }

  bool validateChangePassword() {
    return validateAll(['password', 'newPassword', 'confirmNewPassword']);
  }

  bool validateBillingInfo() {
    return validateAll(['email', 'fullName', 'phone']);
  }

  void initialValue(Profile profile) {
    controllers['fullName']?.text = profile.fullName ?? '';
    controllers['phone']?.text = profile.phone ?? '';
    controllers['gender']?.text = profile.gender ?? '';
    controllers['country']?.text = profile.country ?? '';
    controllers['city']?.text = profile.city ?? '';
    controllers['state']?.text = profile.state ?? '';
    controllers['address']?.text = profile.address ?? '';
    notifyListeners();
  }

  void togglePasswordVisibility() {
     _isPasswordVisible = !_isPasswordVisible;
     notifyListeners();
  }
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }
}
