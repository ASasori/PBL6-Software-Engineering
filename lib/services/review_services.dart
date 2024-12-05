import 'package:booking_hotel_app/models/review.dart';
import 'api_services.dart';

class ReviewServices {
  final ApiService _apiService = ApiService();
  String? baseUrl;

  ReviewServices() {
    baseUrl = _apiService.baseUrl;
  }
  
  Future<List<Review>> fetchReviewsByHotel (String hid) async{
    try {
      final response = await _apiService.dio.get('$baseUrl/api/reviews/hotel-reviews/$hid/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}