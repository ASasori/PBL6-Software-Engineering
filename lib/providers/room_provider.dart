import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../models/room.dart';
import '../services/api_services.dart';

class RoomProvider with ChangeNotifier {
  List<RoomType> _allRoomtypes = [];
  List<Room> _allRoomsInRoomType = [];
  bool isLoading = true;

  List<RoomType> get allRoomtypes => _allRoomtypes;
  List<Room> get allRoomsInRoomType => _allRoomsInRoomType;

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
  Future<void> getRoomsInRoomtype (String hotelSlug, RoomType roomtype) async {
    isLoading = true;
    notifyListeners();
    try {
      _allRoomsInRoomType = await RoomService().fetchRoomsInRoomtype(hotelSlug, roomtype );
      print('Total rooms: ${_allRoomsInRoomType.length}');
    } catch (error) {
      print('Error fetching rooms: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
