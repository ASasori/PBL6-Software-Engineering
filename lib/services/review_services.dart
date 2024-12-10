import 'dart:convert';

import 'package:booking_hotel_app/models/review.dart';
import 'package:dio/dio.dart';
import 'api_services.dart';

class ReviewServices {
  final ApiService _apiService = ApiService();
  String? baseUrl;

  ReviewServices() {
    baseUrl = _apiService.baseUrl;
  }

  Future<Map<String, dynamic>> fetchReviewsByHotel (String hid) async{
    try {
      final response = await _apiService.dio.get('$baseUrl/api/reviews/hotel-reviews/$hid/');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data;
      } else {
        throw('Fail to load review list');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<Review?> postReview(int hotelId, int hotelRating, String? reviewText) async {
    try {
      final response = await _apiService.dio.post(
        '$baseUrl/api/reviews/post/',
        options: Options(
          contentType: 'application/json',
        ),
        data: jsonEncode({
          'hotel': hotelId,
          'rating': hotelRating,
          'review_text': reviewText,
        }),
      );
      if (response.statusCode == 201) {
        return Review.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}