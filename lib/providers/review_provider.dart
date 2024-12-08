import 'package:booking_hotel_app/models/review.dart';
import 'package:booking_hotel_app/services/review_services.dart';
import 'package:flutter/cupertino.dart';

class ReviewProvider with ChangeNotifier {
  ReviewServices _reviewServices = ReviewServices();
  bool _isLoading = false;
  double _hotelRating = 0.0;
  late int _reviewHotel;
  List<Review> _reviewList = [];
  Map<String, dynamic> _mapResponse = {};

  bool get isLoading => _isLoading;
  List<Review> get reviewList => _reviewList;
  double get hotelRating => _hotelRating;
  int get reviewHotel => _reviewHotel;

  Future<void> fetchReviewList (String hid) async {
    try {
      _mapResponse = await _reviewServices.fetchReviewsByHotel(hid);
      final reviewsData = _mapResponse['reviews'];
      if (reviewsData is List) {
        _reviewList = reviewsData.map((json) => Review.fromJson(json)).toList();
      } else {
        _reviewList = [];
        throw ("Invalid data: reviews is not a list");
      }
      // _reviewList = _mapResponse['reviews'].map((json) => Review.fromJson(json)).toList();
      _reviewHotel = _mapResponse['hotel_id'];
      if (_reviewList.isNotEmpty) {
        double rating = 0.0;
        for (var review in _reviewList) {
          rating += review.rating.toDouble();
        }
        _hotelRating = rating / _reviewList.length;
      } else {
        _hotelRating = 0.0;
      }
      notifyListeners();
    } catch (e) {
      _reviewList = [];
      notifyListeners();
      throw ("Review list is empty");
    }
  }

  Future<void> postReview (int hotelId, int rating, String? reviewText) async {
    try {
      Review? newReview = await _reviewServices.postReview(
          hotelId, rating, reviewText);
      if (newReview != null) {
        _reviewList.add(newReview);
        notifyListeners();
      } else {
        throw ("Failed to post review");
      }
    } catch (e) {
      debugPrint("Error posting review: $e");
      throw ("Failed to post review");
    }
  }
}