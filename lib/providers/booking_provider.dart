import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../services/booking_services.dart';

class BookingProvider extends ChangeNotifier {
  final BookingServices _bookingServices = BookingServices();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> addCartItem(
      int roomId, DateTime checkinDate, DateTime checkoutDate, int adult, int children) async {
    _isLoading = true;
    notifyListeners();

    String checkInDateString = DateFormat('yyyy-MM-dd').format(checkinDate);
    String checkOutDateString = DateFormat('yyyy-MM-dd').format(checkoutDate);

    final status = await _bookingServices.addCartItem(
      roomId,
      checkInDateString,
      checkOutDateString,
      adult,
      children,
    );

    _isLoading = false;
    notifyListeners();
    return status; // Return error message or null if successful
  }
}
