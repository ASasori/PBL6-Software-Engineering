import 'dart:convert';

class RoomType {
  final String hotelId;
  final String type;
  final double price;
  final int numberOfBeds;
  final String imageUrl;
  final int roomCapacity;
  final String rtid;
  final String slug;
  final DateTime dateAdded;

  RoomType({
    required this.hotelId,
    required this.type,
    required this.price,
    required this.numberOfBeds,
    required this.imageUrl,
    required this.roomCapacity,
    required this.rtid,
    required this.slug,
    required this.dateAdded,
  });

  // Tạo RoomType từ JSON
  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      hotelId: json['hotel_id'] ?? '',
      type: json['type'] ?? '',
      price:double.parse(json['price']) ?? 0.0,
      numberOfBeds: json['number_of_beds'] ?? 0,
      // imageUrl: json['image'] = 'http://192.168.1.4:8000${json['image']}',
      imageUrl: json['image'] = 'http://192.168.1.225:8000${json['image']}',
      roomCapacity: json['room_capacity'] ?? 0,
      rtid: json['rtid'] ?? '',
      slug: json['slug'] ?? '',
      dateAdded: DateTime.parse(json['date']),
    );
  }

  // Chuyển RoomType sang JSON
  Map<String, dynamic> toJson() {
    return {
      'hotel_id': hotelId,
      'type': type,
      'price': price,
      'number_of_beds': numberOfBeds,
      'image': imageUrl,
      'room_capacity': roomCapacity,
      'rtid': rtid,
      'slug': slug,
      'date': dateAdded.toIso8601String(),
    };
  }
}

class Room {
  final String hotelId;
  final RoomType roomType; // Liên kết trực tiếp với RoomType thay vì chỉ lưu roomTypeId
  final String roomNumber;
  final bool isAvailable;
  final String rid;
  final DateTime dateAdded;

  Room({
    required this.hotelId,
    required this.roomType,
    required this.roomNumber,
    required this.isAvailable,
    required this.rid,
    required this.dateAdded,
  });

  // Tạo Room từ JSON
  factory Room.fromJson(Map<String, dynamic> json, RoomType roomType) {
    return Room(
      hotelId: json['hotel_id'] ?? '',
      roomType: roomType, // Ánh xạ RoomType khi tạo Room từ JSON
      roomNumber: json['room_number'] ?? '',
      isAvailable: json['is_available'] ?? true,
      rid: json['rid'] ?? '',
      dateAdded: DateTime.parse(json['date']),
    );
  }

  // Chuyển Room sang JSON
  Map<String, dynamic> toJson() {
    return {
      'hotel_id': hotelId,
      'room_type_id': roomType.rtid,
      'room_number': roomNumber,
      'is_available': isAvailable,
      'rid': rid,
      'date': dateAdded.toIso8601String(),
    };
  }

  // Getter lấy thông tin từ RoomType
  String get type => roomType.type;
  String? get imageUrl => roomType.imageUrl;
  int get numberOfBeds => roomType.numberOfBeds;
  int get roomCapacity => roomType.roomCapacity;
  double get price => roomType.price;
}
