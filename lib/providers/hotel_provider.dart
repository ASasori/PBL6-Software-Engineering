import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../models/hotel.dart';
import '../models/location.dart';
import '../services/hotel_services.dart';

class HotelProvider with ChangeNotifier {
  final HotelServices _hotelServices = HotelServices();
  Completer<void> _fetchDetailCompleter = Completer<void>();

  List<Hotel> _hotels = [];
  List<Hotel> _topHotels = [];
  List<Location> _locations = [];
  List<Hotel> _hotelsByLocation = [];
  bool _isLoading = false;
  late Hotel _hotelDetail;

  List<Hotel> get hotels => _hotels;
  List<Hotel> get topHotels => _topHotels;
  List<Location> get locations => _locations;
  List<Hotel> get hotelsByLocation => _hotelsByLocation;
  bool get isLoading => _isLoading;
  Hotel get hotelDetail => _hotelDetail;

  Future<void> fetchHotels() async {
    _isLoading = true;
    notifyListeners();
    try {
      _hotels = await _hotelServices.fetchHotelsByLocation("", "");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _hotels = [];
      _isLoading = false;
      notifyListeners();
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
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _topHotels = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchLocations() async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      _locations = await _hotelServices.fetchLocations();
      notifyListeners();
    } catch (e) {
      _locations = [];
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHotelsByLocation(String location, String name) async {
    _isLoading = true;
    try {
      _isLoading = false;
      _hotelsByLocation = await _hotelServices.fetchHotelsByLocation(location, name);
      _topHotels = _hotelsByLocation;
      notifyListeners();
    } catch (e) {
      _hotelsByLocation = [];
      _topHotels = [];
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHotelsBySlug(String hotelSlug) async {
    try {
      _isLoading = true;
      _hotelDetail = await _hotelServices.fetchHotelsByHotelSlug(hotelSlug);
      notifyListeners();
    } catch (e) {
      print('Error fetch hotel by slug: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
}
