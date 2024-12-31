import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
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

  // Future<void> fetchHotels() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _hotels = await _hotelServices.fetchHotelsByLocation("", "", null, null);
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _hotels = [];
  //     _isLoading = false;
  //     notifyListeners();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
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

  Future<void> fetchHotelsByLocation(String location, String name, String? priceMin, String? priceMax) async {
    _isLoading = true;
    try {
      _isLoading = false;
      _hotelsByLocation = await _hotelServices.fetchHotelsByLocation(location, name, priceMin, priceMax);
      notifyListeners();
    } catch (e) {
      _hotelsByLocation = [];
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
  Future<Map<String, dynamic>> getCurrentCity() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw "Please enable location services.";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location access denied.";
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw "Location access is permanently denied.";
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String cityName = await _hotelServices.fetchCityName(position.latitude, position.longitude);
      return {
        'cityName': cityName,
        'isSuccess': true,
      };
    } catch (e) {
      return {
        'errorMessage': e.toString(),
        'isSuccess': false,
      };
    }
  }
  void sortHotel (int methodIndex){
    if (methodIndex == 0) {
      _hotelsByLocation.sort((a,b) => a.priceMin.compareTo(b.priceMin));
    } else if(methodIndex == 1) {
      _hotelsByLocation.sort((a,b) => b.priceMin.compareTo(a.priceMin));
    } else if (methodIndex == 2) {
      _hotelsByLocation.sort((a,b) => a.averageRating.compareTo(b.averageRating));
    } else  {
      _hotelsByLocation.sort((a,b) => b.averageRating.compareTo(a.averageRating));
    }
  }
}
