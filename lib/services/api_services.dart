import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:booking_hotel_app/models/location.dart';

class TokenManager {
  static String? _token;
  static String? get token => _token;
  static set token (String? value){
    _token = value;
  }
}
class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handle) {
        if (TokenManager.token != null){
          options.headers['Authorization'] = 'Token ${TokenManager.token}';
        }
        return handle.next(options);
      },
      onError: (DioError error, handle){
        return handle.next(error);
      }
    ));
  }
  Dio get dio => _dio;
}
class HotelServices {
  // final Dio _dio = Dio();

  final ApiService _apiService = ApiService();
  // static const String baseUrl = 'http://10.10.3.249:8000';
  // static const String baseUrl = 'http://192.168.1.23:8000';
  // static const String baseUrl = 'http://192.168.43.21:8000';
  static const String baseUrl = 'http://192.168.2.25:8000';

  Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await _apiService.dio.get('$baseUrl/api/detail/');
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
      final response = await _apiService.dio.get('$baseUrl/api/detail/');
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
      final response = await _apiService.dio.get('$baseUrl/api/detail/location/');
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
      final response = await _apiService.dio.post(
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
  // static const String baseUrl = 'http://192.168.43.21:8000';
  static const String baseUrl = 'http://192.168.2.25:8000';


  Future<String?> fetchCsrfToken() async {
    try {
      final response = await _dio.get('$baseUrl/user/api/userauths/csrftoken/');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final cookies = response.headers.map['set-cookie'];
        if (cookies != null) {
          print('Cookies: $cookies');
          final csrfToken = RegExp(r'csrftoken=([^;]+)').firstMatch(cookies.join(','));
          if (csrfToken != null) {
            print('CSRF Token found: ${csrfToken.group(1)}');
            return csrfToken.group(1);
          } else {
            print('CSRF Token not found in cookies');
          }
        } else {
          print('No cookies found in response headers');
        }
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
    }
    return null;
  }

  Future<bool> login(String email, String password) async {

    final csrfToken = await fetchCsrfToken();

    if (csrfToken == null) {
      print("Failed to fetch CSRF Token");
      return false;
    }

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
        TokenManager.token = response.data['token'];
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