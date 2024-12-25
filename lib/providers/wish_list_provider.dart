import 'package:booking_hotel_app/services/hotel_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/hotel.dart';
import '../models/wishlist_item.dart';
import '../services/wishlist_services.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistServices _wishlistServices = WishlistServices();
  final HotelServices _hotelServices = HotelServices();
  bool _isLoading = false;
  Map<String, dynamic> _cart = {};
  int _counter = 0;
  List<WishlistItem> _wishlist = [];
  double _totalPrice = 0.0;

  Map<String, dynamic> get cart => _cart;

  bool get isLoading => _isLoading;

  int get counter => _counter;

  List<WishlistItem> get wishlist => _wishlist;

  double get totalPrice => _totalPrice;

  void addCounter() {
    _counter++;
    notifyListeners();
  }

  Future<int> getCartItemCount() async {
    try {
      _isLoading = true;
      notifyListeners();
      _counter = await _wishlistServices.getCartItemCount();
      _isLoading = false;
      notifyListeners();
      return _counter;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Error: $e");
      throw ("Failed to load cart item count");
    }
  }

  // void updateCheckinDateOrCheckoutDate(String id ,DateTime startDate, DateTime endDate) {
  //   final index = wishilist.indexWhere((element) => element.bookingID == id);
  //
  //   wishilist[index].startDate = startDate;
  //   wishilist[index].endDate = endDate;
  //
  //   notifyListeners();
  // }

  void removeTotalPrice(double price) {
    _totalPrice = _totalPrice - price;
    notifyListeners();
  }

  Future<String?> addCartItem(int roomId, DateTime checkInDate,
      DateTime checkOutDate, int adult, int children) async {
    _isLoading = true;
    notifyListeners();

    String checkInDateString = DateFormat('yyyy-MM-dd').format(checkInDate);
    String checkOutDateString = DateFormat('yyyy-MM-dd').format(checkOutDate);

    final status = await _wishlistServices.addCartItem(
      roomId,
      checkInDateString,
      checkOutDateString,
      adult,
      children,
    );
    _isLoading = false;
    notifyListeners();
    return status;
  }

  Future<void> fetchWishlist() async {
    try {
      _cart = await _wishlistServices.fetchCart();
      final hotels = cart['hotels'];

      if (hotels == null || hotels.isEmpty) {
        _wishlist = [];
        _totalPrice = 0.0;
        notifyListeners();
        return;
      }

      List<WishlistItem> loadedWishlist = [];
      double price = 0.0;
      for (var hotel in hotels) {
        final hotelId = hotel['hotel_id'];
        final hotelName = hotel['hotel_name'];
        final hotelSlug = hotel['hotel_slug'][0];
        late Hotel hotelData;
        try {
          hotelData = await _hotelServices.fetchHotelsByHotelSlug(hotelSlug);
        } catch (e) {
          print("Error detail hotel: $e");
        }
        final hotelAddress = hotelData.address;
        final hotelImage = hotelData.galleryImages[0].imageUrl;
        for (var room in hotel['rooms']) {
          final checkInDate = DateTime.parse(room['check_in_date']);
          final checkOutDate = DateTime.parse(room['check_out_date']);

          final startDate = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
          final endDate = DateTime(checkOutDate.year, checkOutDate.month, checkOutDate.day);

          final totalAmount = room['price'] *
              ((endDate).difference(startDate).inDays + 1);
          price += totalAmount;
          loadedWishlist.add(WishlistItem(
            hotelId: hotelId,
            hotelName: hotelName,
            address: hotelAddress,
            imageUrl: hotelImage,
            itemCartId: room['item_cart_id'],
            startDate: startDate,
            endDate: endDate,
            typeRoom: room['room_type'],
            rt_slug: room['slug_room_type'],
            roomId: room['room_id'],
            roomNumber: room['room_number'],
            bed: room['bed'],
            pricePernight: room['price'],
            totalAmount: totalAmount,
            adult: room['adults_count'],
            children: room['childrens_count'],
          ));
        }
      }
      _counter = loadedWishlist.length;
      _wishlist = loadedWishlist;
      _totalPrice = price;
      notifyListeners();
    } catch (error) {
      _wishlist = [];
      print("Error from file provider: $error");
      notifyListeners();
    }
  }

  void removeWishlistItemById(int id) {
    _wishlist.removeWhere((item) => item.itemCartId == id);
    notifyListeners();
  }

  Future<String?> deleteCartItem(int id) async {
    _isLoading = true;
    notifyListeners();

    final status = await _wishlistServices.deleteCartItem(id);
    if (status == null) {
      removeWishlistItemById(id);
      _counter--;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
    return status;
  }
}
