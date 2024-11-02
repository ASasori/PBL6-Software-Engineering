import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../models/hotel.dart';
import '../models/location.dart';
import '../services/api_services.dart';

class HotelProvider with ChangeNotifier {
  final HotelServices _hotelServices = HotelServices();
  Completer<void> _fetchDetailCompleter = Completer<void>();

  List<Hotel> _hotels = [];
  List<Hotel> _topHotels = [];
  List<Location> _locations = [];
  List<Hotel> _hotelsByLocation = [];
  bool _isLoading = false;

  List<Hotel> get hotels => _hotels;
  List<Hotel> get topHotels => _topHotels;
  List<Location> get locations => _locations;
  List<Hotel> get hotelsByLocation => _hotelsByLocation;
  bool get isLoading => _isLoading;

  Future<void> fetchHotels() async {
    _isLoading = true;
    notifyListeners();
    try {
      _hotels = await _hotelServices.fetchHotels();
      if (!_fetchDetailCompleter.isCompleted) {
        _fetchDetailCompleter.complete();
      }
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
  Future<void> fetchLocations() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _fetchDetailCompleter.future;
      _locations = await _hotelServices.fetchLocations();
      _fetchDetailCompleter = Completer<void>();
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Hotel>> fetchHotelsByLocation(String location, String name) async {
    _isLoading = true;
    // notifyListeners();
    try {
      _hotelsByLocation = await _hotelServices.fetchHotelsByLocation(location, name);
      return _hotelsByLocation;
    } catch (e) {
      print(e);
      return [];
    } finally {
      _isLoading = false;
      // notifyListeners();
    }
  }
}
