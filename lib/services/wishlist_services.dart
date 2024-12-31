import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_services.dart';

class WishlistServices {
  final ApiService _apiService = ApiService();
  String? baseUrl;

  WishlistServices() {
    baseUrl = _apiService.baseUrl;
  }
  Future<String?> addCartItem (int roomId, String checkinDate, String checkoutDate, int adult, int children) async {
    try {
      final response = await _apiService.dio.post(
        '${baseUrl}/api/add-cart-item/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          "room": roomId,
          "check_in_date": checkinDate,
          "check_out_date": checkoutDate,
          "num_adults": adult,
          "num_children": children,
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
      return "Room may already be added for the selected dates.";
    }
  }

  Future<Map<String, dynamic>> fetchCart() async {
    try {
      final response = await _apiService.dio.get('$baseUrl/api/view_cart/');
      if (response.statusCode == 200) {
        if (response.data['hotels'] == null) {
          throw Exception('No hotels found in cart');
        }
        return response.data;
      } else {
        throw Exception('Failed to load your cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getCartItemCount() async {
    try {
      final response = await _apiService.dio.get('$baseUrl/api/get_cart_item_count/');
      if (response.statusCode == 200) {
        return response.data["total_items_in_cart"];
      } else {
        throw Exception('Failed to load cart item count');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteCartItem (int id) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/api/delete_cart_item/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'item_cart_id': id,
        }),
      );
      if (response.statusCode == 204) {
        return null;
      } else {
        return response.data['error'];
      }
    } catch (e) {
      return ("Delete failed");
    }
  }
}