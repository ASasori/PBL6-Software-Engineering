import 'dart:async';
import 'package:booking_hotel_app/models/available_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/room.dart';
import '../services/room_services.dart';

class RoomProvider with ChangeNotifier {
  List<RoomType> _allRoomtypes = [];
  List<Room> _allRoomsInRoomType = [];
  List<AvailableRoom> _allAvailableRooms = [];
  bool _isLoading = false;

  List<RoomType> get allRoomtypes => _allRoomtypes;

  List<Room> get allRoomsInRoomType => _allRoomsInRoomType;

  List<AvailableRoom> get allAvailableRooms => _allAvailableRooms;

  bool get isLoading => _isLoading;

  void resetAvailableRooms () {
    _allAvailableRooms = [];
    notifyListeners();
  }
  Future<void> getAllRoomTypeList(String hotelSlug) async {
    _isLoading = true;
    notifyListeners();
    try {
      _allRoomtypes = await RoomService().fetchRoomTypes(hotelSlug);
    } catch (error) {
      print('Error fetching rooms: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRoomsInRoomType(String hotelSlug, RoomType roomtype) async {
    _isLoading = true;
    notifyListeners();
    try {
      _allRoomsInRoomType =
          await RoomService().fetchRoomsInRoomType(hotelSlug, roomtype);
    } catch (error) {
      print('Error fetching rooms: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAvailableRooms(
      String hotelSlug,
      RoomType roomtype,
      DateTime checkInDate,
      DateTime checkOutDate,
      int adult,
      int children) async {
    _isLoading = true;
    notifyListeners();
    try {
      String checkInDateString = DateFormat('yyyy-MM-dd').format(checkInDate);
      String checkOutDateString = DateFormat('yyyy-MM-dd').format(checkOutDate);
      final results = await RoomService().fetchAvailableRooms(hotelSlug,
          roomtype, checkInDateString, checkOutDateString, adult, children);

      final rooms = results['available_rooms'];
      if (rooms == null || rooms.isEmpty) {
        _allAvailableRooms = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      List<AvailableRoom> loadedAvailableRoom = [];
      for (var room in rooms) {
        print("room available!!!");
        loadedAvailableRoom.add(AvailableRoom(
          hotelSlug: results['slug'],
          hotelName: results['hotel'],
          roomType: results['room_type'],
          checkInDate: DateTime.parse(results['checkin']),
          checkOutDate: DateTime.parse(results['checkout']),
          adults: results['adults'] ?? 0,
          children: results['children'] ?? 0,
          roomId: room['room_id'],
          roomNumber: room['room_number'],
          capacity: room['capacity'],
          bed: room['bed'],
          price: (room['price'] != null) ? room['price'].toDouble() : null,
        ));
      }
      _allAvailableRooms = loadedAvailableRoom;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _allAvailableRooms = [];
      notifyListeners();
    }
  }
}
