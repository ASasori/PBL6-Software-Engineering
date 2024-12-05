import 'package:booking_hotel_app/models/review.dart';
import 'package:booking_hotel_app/services/review_services.dart';
import 'package:flutter/cupertino.dart';

class ReviewProvider with ChangeNotifier {
  ReviewServices _reviewServices = ReviewServices();
  bool _isLoading = false;
  List<Review> _reviewList = [];

  bool get isLoading => _isLoading;
  List<Review> get reviewList => _reviewList;

  Future<void> fetchReviewList (String hid) async {
    try {
      print("hid: $hid");
      _reviewList = await _reviewServices.fetchReviewsByHotel(hid);
      notifyListeners();
    } catch (e) {
      print("Error: $e");
      _reviewList =[];
      notifyListeners();
    }
  }
}