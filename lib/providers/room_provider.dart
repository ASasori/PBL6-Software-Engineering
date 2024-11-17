import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../models/room.dart';
import '../services/api_services.dart';

class RoomProvider with ChangeNotifier {
  List<Room> rooms = [];
  bool isLoading = true;

  Future<void> getRoomList(String hotelSlug) async {
    isLoading = true;
    notifyListeners();
    try {
      rooms = await RoomService().fetchRoomsByHotelSlug(hotelSlug);
      print('Total rooms: ${rooms.length}');
    } catch (error) {
      print('Error fetching rooms: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
