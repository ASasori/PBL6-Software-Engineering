import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/room.dart';
import 'api_services.dart';

class RoomService {
  final ApiService _apiService = ApiService();
  String? baseUrl;
  RoomService(){
    baseUrl = _apiService.baseUrl;
  }
  Future <List<Room>> fetchRoomsInRoomtype (String hotelSlug, RoomType roomtype) async{
    String rt_slug = roomtype.slug;
    List<Room> allRoomsInRoomType = [];
    final roomResponse = await _apiService.dio.get('$baseUrl/api/hotels/$hotelSlug/room-types/$rt_slug/rooms/');
    if (roomResponse.statusCode == 200){
      Map<String, dynamic> roomData = roomResponse.data;
      for (var roomJson in roomData['listroom']) {
        Room room = Room.fromJson(roomJson, roomtype);
        allRoomsInRoomType.add(room);
      }
    }else {
      throw Exception('Failed to load rooms for room type $rt_slug');
    }
    return allRoomsInRoomType;
  }
  Future<List<RoomType>> fetchRoomtypes(String hotelSlug) async {
    try {
      final response = await _apiService.dio.get(
          '$baseUrl/api/hotels/$hotelSlug/room-types/');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> roomtypeData = data["roomtype"];
        return roomtypeData.map((json) => RoomType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load roomtypes by $hotelSlug');
      }
    } catch (e) {
      print('Error fetching roomtypes: $e');
      rethrow;
    }
  }
}