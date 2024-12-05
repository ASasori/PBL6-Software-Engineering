import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:booking_hotel_app/models/location.dart';
import '../models/cart.dart';
import 'api_services.dart';

class HotelServices {
  // final Dio _dio = Dio();

  final ApiService _apiService = ApiService();
  String? baseUrl;

  HotelServices() {
    baseUrl = _apiService.baseUrl;
  }

  Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await _apiService.dio.get('$baseUrl/api/hotels/');
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
      final response = await _apiService.dio.get('$baseUrl/api/hotels/');
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
  Future<Hotel> fetchHotelsByHotelSlug(String hotel_slug) async {
    try {
      final response = await _apiService.dio.get('$baseUrl/api/hotels/$hotel_slug/');
      if (response.statusCode == 200) {
        dynamic data = response.data;
        return Hotel.fromJson(data);
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
      final response = await _apiService.dio.get('$baseUrl/api/locations/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load location');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching data location');
    }
  }

  Future<List<Hotel>> fetchHotelsByLocation(String location,
      String name) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/api/locations/hotels_by_location/',
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