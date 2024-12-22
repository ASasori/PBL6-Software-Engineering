import '../utils/localfiles.dart';

class RoomType {
  final int roomtypeId;
  final int hotelId;
  final String type;
  final double price;
  final int numberOfBeds;
  final String imageUrl;
  final int roomCapacity;
  final String rtid;
  final String slug;
  final DateTime dateAdded;

  RoomType({
    required this.roomtypeId,
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
    const String baseUrl = Localfiles.baseUrl ;
    return RoomType(
      roomtypeId: json['id'] ?? '',
      hotelId: json['hotel'] ?? '',
      type: json['type'] ?? '',
      price:double.parse(json['price']),
      numberOfBeds: json['number_of_beds'] ?? 0,
      imageUrl: json['image'] = '$baseUrl${json['image']}',
      roomCapacity: json['room_capacity'] ?? 0,
      rtid: json['rtid'] ?? '',
      slug: json['slug'] ?? '',
      dateAdded: DateTime.parse(json['date']),
    );
  }

  // Chuyển RoomType sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': roomtypeId,
      'hotel': hotelId,
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
  final int roomId;
  final int hotelId;
  final RoomType roomType;
  final String roomNumber;
  final bool isAvailable;
  final String rid;
  final DateTime dateAdded;

  Room({
    required this.roomId,
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
      roomId: json['id'] ?? '',
      hotelId: json['hotel'] ?? '',
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
      'id': roomId,
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
