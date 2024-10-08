import 'package:flutter/cupertino.dart';
import '../models/hotel.dart';
import '../services/api_services.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];
  List<Hotel> _topHotels = [];
  bool _isLoading = false;
  final HotelServices _hotelServices = HotelServices();

  List<Hotel> get hotels => _hotels;
  List<Hotel> get topHotels => _topHotels;
  bool get isLoading => _isLoading;

  Future<void> fetchHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      _hotels = await _hotelServices.fetchHotels();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchTopHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      _topHotels = await _hotelServices.fetchTopHotels();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
