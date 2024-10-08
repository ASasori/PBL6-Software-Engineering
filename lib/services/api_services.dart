import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';

class HotelServices {
  final Dio _dio = Dio();
  // static const String baseUrl = 'http://10.10.3.249:8000';
  static const String baseUrl = 'http://192.168.1.11:8000';

  Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await _dio.get('$baseUrl/api/detail/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        // convert data fromJson to List<Hotel>
        return data.map((json) => Hotel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching data api');
    }
  }
  Future<List<Hotel>> fetchTopHotels() async {
    try {
      final response = await _dio.get('$baseUrl/api/detail/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        // convert data fromJson to List<Hotel>
        return data.map((json) => Hotel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching data api');
    }
  }
}

// call api auth
class AuthService {
  final Dio _dio = Dio();
  // static const String baseUrl = 'http://10.10.3.249:8000';
  // static const String baseUrl = 'http://192.168.1.23:8000';
  static const String baseUrl = 'http://192.168.1.11:8000';

  Future<String?> fetchCsrfToken() async {
    try {
      // final response = await dio.get('http://10.10.3.249:8000/');
      final response = await _dio.get('$baseUrl/');
      print('Response headers: ${response.headers}');
      if (response.statusCode == 200) {
        // Lấy cookie từ headers
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          // Tìm CSRF token trong cookie
          final csrfToken = RegExp(r'csrftoken=([^;]+)').firstMatch(cookies.join(','));
          if (csrfToken != null) {
            return csrfToken.group(1); // Trả về giá trị CSRF token
          }
        }
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
    }
    return null;
  }

  Future<bool> login(String email, String password) async {
    final csrfToken = await fetchCsrfToken();
    print('CSRF Token: $csrfToken');
    try {
      final response = await _dio.post(
        '$baseUrl/user/api/userauths/login/',
        // 'http://10.10.3.249:8000/user/api/userauths/login/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'X-CSRFToken': csrfToken ?? '', // Thêm CSRF token vào header
          },
        ),
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        print('Login successful: ${response.data}');
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
    final csrfToken = await fetchCsrfToken();
    print('CSRF Token: $csrfToken');
    print("$email, $password, $username, $full_name, $phone");
    try {
      final response = await _dio.post(
        // 'http://10.10.3.249:8000/user/api/userauths/register/',
        '$baseUrl/user/api/userauths/register/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'X-CSRFToken': csrfToken ?? '', // Thêm CSRF token vào header
          },
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