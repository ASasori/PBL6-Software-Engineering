import 'dart:convert';
import 'package:booking_hotel_app/models/profile.dart';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/token_manager.dart';
import 'api_services.dart';
import 'package:booking_hotel_app/utils/localfiles.dart';

class AuthService {
  final Dio _dio = Dio();

  final ApiService _apiService = ApiService();
  static const String baseUrl = Localfiles.baseUrl;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/user/api/userauths/login/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Lấy các token và role từ response
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        final role = response.data['role'];

        // Lưu các token vào TokenManager
        TokenManager.accessToken = accessToken;
        TokenManager.refreshToken = refreshToken;
        TokenManager.role = role;

        print(
            'Login successful: AccessToken: $accessToken, '
                'RefreshToken: $refreshToken, Role: $role');
        return true;
      } else {
        print('Login failed: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> register( String email, String password,
      String username, String phone) async {
    try {
      final response = await _dio.post(
        '$baseUrl/user/api/userauths/register/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'phone': phone
        }),
      );

      if (response.statusCode == 201) {
        print('Register successful: ${response.data}');
        return true;
      } else {
        print('Register failed: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during register: $e');
      return false;
    }
  }
  Future<Map<String, dynamic>> fetchProfile () async {
    try {
      final response = await _apiService.dio.get("${baseUrl}/user/api/userauths/profile/");
      if (response.statusCode == 200) {
        return response.data;
      } else throw ('Failed to load profile');
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> resetPassword (String email) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/user/api/userauths/auth/reset-password/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error reset password: $e');
      return false;
    }
  }
  Future<bool> changePassword (String oldPassword, String newPassword) async {
    try {
      final response = await _apiService.dio.patch(
          '$baseUrl/user/api/userauths/change-password/',
        options: Options(
          contentType: 'application/json'
        ),
        data: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        })
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error api change Password: $e');
      return false;
    }
  }
  Future<Profile> updateProfile({
    String? fullName,
    String? phone,
    String? gender,
    String? country,
    String? city,
    String? state,
    String? address,
    String? imagePath,
    String? identityImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (address != null) 'address': address,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
        if (identityImagePath != null) 'indentity_image': await MultipartFile
            .fromFile(identityImagePath),
      });

      final response = await _apiService.dio.patch(
        '$baseUrl/user/api/userauths/profile/edit/',
        options: Options(
          contentType: 'application/json',
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error update profile: $e');
      throw Exception('Error updating profile');
    }
  }
}
