import 'package:booking_hotel_app/models/booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/booking_services.dart';

class BookingProvider extends ChangeNotifier {
  String Publishablekey =
      "pk_test_51Q7TR2B1Dpb6dXWmD5g6dAuCHf5Co92kXqxZOI2yTOuC4lnZYSa6EGmYaZjAhfYVqMAXlPWft1HaIJT01qW29RVF0009iOraPk";
  String Secretkey =
      "sk_test_51Q7TR2B1Dpb6dXWmXNRStuPl01fVTeLAldCoudxmojsxj2ItvE5ebRctIHHOt0vznsI2KO8LTRuc9Ftcm112Hman00huhYGhWI";
  late final BookingServices _bookingServices;

  BookingProvider() {
    _bookingServices =
        BookingServices(secretKey: Secretkey, publishableKey: Publishablekey);
  }

  BookingData _bookingData = BookingData();
  List<BookingData> _myBookings = [];
  List<BookingData> _myUpcomingBookings = [];
  List<BookingData> _myFinishedBookings = [];
  double _discount = 0.0;
  bool _isLoading = false;

  BookingData get bookingData => _bookingData;

  bool get isLoading => _isLoading;

  double get discount => _discount;

  List<BookingData> get myUpcomingBookings => _myUpcomingBookings;
  List<BookingData> get myFinishedBookings => _myFinishedBookings;

  void resetBookingData() {
    _bookingData = BookingData();
    _discount = 0.0;
    notifyListeners();
  }

  Future<bool> continueCheckout(
      int hotelId,
      int roomId,
      DateTime checkInDate,
      DateTime checkOutDate,
      int adults,
      int children,
      String rt_slug,
      double totalAmount,
      String fullName,
      String email,
      String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      String checkInDateString = DateFormat('yyyy-MM-dd').format(checkInDate);
      String checkOutDateString = DateFormat('yyyy-MM-dd').format(checkOutDate);
      final result = await _bookingServices.createBooking(
          hotelId,
          roomId,
          checkInDateString,
          checkOutDateString,
          adults,
          children,
          rt_slug,
          totalAmount,
          fullName,
          email,
          phone);
      if (result is String) {
        _bookingData.bookingID = result;
        notifyListeners();
        return true;
      }
      print("BookingID: ${_bookingData.bookingID}");
      return false;
    } catch (e) {
      print('Error continue checkout: $e');
      return false;
    }
  }

  Future<String?> getDiscount(String bookingId, String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      final results = await _bookingServices.checkCoupon(bookingId, code);
      String? status;
      if (results['booking_total'] != null) {
        _bookingData.totalAmount = results['booking_total'] as double;
        _discount = results['discount'] as double;
        status = null;
      } else {
        status = 'Coupon is invalid';
      }
      notifyListeners();
      return status;
    } catch (e) {
      print('Error get dis count: $e');
      return 'Coupon is invalid';
    }
  }

  Future<bool> initialCheckout(int totalAmount, String currency,
      String bookingId, int cartItemId) async {
    try {
      bool statusPayment = await _bookingServices.paymentSheetInitialization(
          totalAmount.toString(), currency, bookingId, cartItemId);
      notifyListeners();
      return statusPayment;
    } catch (e) {
      if (kDebugMode) {
        print("Error during checkout: $e");
      }
      return false;
    }
  }
  Future<void> getMyBookings () async{
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      _myBookings = await _bookingServices.fetchMyBookings();
      for (BookingData myBooking in _myBookings) {
        if (myBooking.endDate!.isBefore(DateTime.now())) {
          _myFinishedBookings.add(myBooking);
        } else{
          _myUpcomingBookings.add(myBooking);
        }
      }
      notifyListeners();
    } catch (e) {
      _myFinishedBookings = [];
      _myUpcomingBookings = [];
      notifyListeners();
      print ('Error provider get history booking list');
    }
  }
}
