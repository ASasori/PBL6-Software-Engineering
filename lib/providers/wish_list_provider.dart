import 'package:booking_hotel_app/models/booking.dart';
import 'package:flutter/cupertino.dart';

import '../utils/localfiles.dart';
import '../services/wishlist_services.dart';

class WishlistProvider with ChangeNotifier{
  int _counter = 2;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 1550.0;
  double get totalPrice => _totalPrice;

  List<BookingData> wishilist = [];

  static List<BookingData> bookingListData = [
    BookingData(
      bookingID: "B001",
      hotelName: "Grand Palace Hotel",
      imagePath: Localfiles.hotel_1,
      address: "123 Main St, City, Country",
      numberOfAdults: 2,
      numberOfChildren: 1,
      typeRoom: "Deluxe",
      pricePernight: 150.0,
      totalAmount: 750.0,
      startDate: DateTime(2024, 12, 1),
      endDate: DateTime(2024, 12, 5),
    ),
    BookingData(
      bookingID: "B002",
      hotelName: "Sea View Resort",
      imagePath: Localfiles.hotel_2,
      address: "456 Beach Rd, City, Country",
      startDate: DateTime(2024, 11, 1),
      endDate: DateTime(2024, 11, 5),
      numberOfAdults: 2,
      numberOfChildren: 2,
      typeRoom: "Family Suite",
      pricePernight: 200.0,
      totalAmount: 800.0,
    ),
  ];

  Future<void> addBookingData(BookingData bookingData) async {
    wishilist.add(bookingData);

  }
  Future<List<BookingData>> getData() async {
    wishilist = bookingListData;
    notifyListeners();
    return wishilist;
  }

  void addCounter() {
    _counter++;
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    notifyListeners();
  }

  int getCounter() {
    return _counter;
  }

  void updateCheckinDateOrCheckoutDate(String id ,DateTime startDate, DateTime endDate) {
    final index = wishilist.indexWhere((element) => element.bookingID == id);

    wishilist[index].startDate = startDate;
    wishilist[index].endDate = endDate;

    notifyListeners();
  }

  void removeItem(String id) {
    final index = wishilist.indexWhere((element) => element.bookingID == id);
    wishilist.removeAt(index);
    notifyListeners();
  }

  void addTotalPrice(double price) {
    _totalPrice = _totalPrice + price;
  }

  void removeTotalPrice(double price) {
    _totalPrice = _totalPrice - price;
    notifyListeners();
  }

  double getTotalPrice() {
    return _totalPrice;
  }

}