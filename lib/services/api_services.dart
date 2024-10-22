import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:booking_hotel_app/models/location.dart';

class HotelServices {
  final Dio _dio = Dio();

  // static const String baseUrl = 'http://10.10.3.249:8000';
  // static const String baseUrl = 'http://192.168.1.23:8000';
  static const String baseUrl = 'http://192.168.43.21:8000';
  // static const String baseUrl = 'http://192.168.1.16:8000';

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
  Future<List<Location>> fetchLocations() async {
    try {
      final response = await _dio.get('$baseUrl/api/detail/location/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load location');
      }
    } catch(e) {
      print(e);
      throw Exception('Error fetching data location');
    }
  }
  Future<List<Hotel>> fetchHotelsByLocation(String location, String name) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/detail/location/hotels_by_location/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'location': location,
          'name': name,
        }),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
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
  // static const String baseUrl = 'http://192.168.1.16:8000';
  static const String baseUrl = 'http://192.168.43.21:8000';


  Future<String?> fetchCsrfToken() async {
    try {
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