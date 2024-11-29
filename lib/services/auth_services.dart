import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/token_manager.dart';
import 'api_services.dart';
import 'package:booking_hotel_app/utils/localfiles.dart';

class AuthService {
  final Dio _dio = Dio();
  // final ApiService _apiService = ApiService();
  static const String baseUrl = Localfiles.baseUrl ;

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

        print('Login successful: AccessToken: $accessToken, RefreshToken: $refreshToken, Role: $role');
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

  Future<bool> register(String username, String email, String password, String full_name, String phone) async {
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
          'full_name': full_name,
          'phone': phone
        }),
      );

      if (response.statusCode == 201) {
        print('Register successful: ${response.data}');
        return true;
      } else {
        // Xử lý lỗi
        print('Register failed: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error during register: $e');
      return false;
    }
  }
}