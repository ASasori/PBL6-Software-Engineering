import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../models/room.dart';
import '../services/api_services.dart';

class RoomProvider with ChangeNotifier {
  List<RoomType> _allRoomtypes = [];
  List<Room> _roomsByRoomType = [];
  bool isLoading = true;

  List<RoomType> get allRoomtypes => _allRoomtypes;
  List<Room> get roomsByRoomType => _roomsByRoomType;

  Future<void> getAllRoomtypeList(String hotelSlug) async {
    isLoading = true;
    notifyListeners();
    try {
      _allRoomtypes = await RoomService().fetchRoomtypes(hotelSlug);
      print('Total rooms: ${_allRoomtypes.length}');
    } catch (error) {
      print('Error fetching rooms: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // Future<void> getRoomByRoomType (String hotelSlug, String rtSlug) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     _allRooms = await RoomService().fetchRoomsByHotelSlug(hotelSlug);
  //     print('Total rooms: ${_allRooms.length}');
  //   } catch (error) {
  //     print('Error fetching rooms: $error');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
