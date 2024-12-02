import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:booking_hotel_app/models/location.dart';
import '../models/cart.dart';
import 'api_services.dart';

class BookingServices {
  final ApiService _apiService = ApiService();
  String? baseUrl;

  BookingServices() {
    baseUrl = _apiService.baseUrl;
  }
  Future<String?> addCartItem (int roomId, String checkinDate, String checkoutDate, int adult, int children) async {
    try {
      final response = await _apiService.dio.post(
        '${baseUrl}/api/add-cart-item',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          "room": roomId,
          "check_in_date": checkinDate,
          "check_out_date": checkoutDate,
          "adult": adult,
          "children": children,
        }),
      );
      if (response.statusCode == 201) {
        return null; // Success, no error
      } else if (response.statusCode == 400) {
        return "Room may already be booked for the selected dates.";
      } else {
        return "Unexpected error occurred while adding the cart item.";
      }
    } catch (e) {
      print("Error in BookingServices: $e");
      return "Failed to add cart item. Room may already be booked for the selected dates.";
    }
  }
}