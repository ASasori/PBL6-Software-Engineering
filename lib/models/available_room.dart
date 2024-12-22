class AvailableRoom {
  int? roomId;
  String? hotelSlug;
  String? hotelName;
  String? roomType;
  DateTime checkInDate;
  DateTime checkOutDate;
  int adults;
  int children;
  String? roomNumber;
  int? capacity;
  int? bed;
  double? price;

  AvailableRoom({
    this.roomId,
    this.hotelSlug,
    this.hotelName,
    this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    this.roomNumber,
    this.capacity,
    this.bed,
    this.price,
  });

  factory AvailableRoom.fromJson(Map<String, dynamic> json) {
    return AvailableRoom(
      roomId: json['room_id'],
      hotelSlug: json['slug'],
      hotelName: json['hotel'],
      roomType: json['room_type'],
      checkInDate: DateTime.parse(json['checkin']),
      checkOutDate: DateTime.parse(json['checkout']),
      adults: json['adults'] ?? 0,
      children: json['children'] ?? 0,
      roomNumber: json['room_number'],
      capacity: json['capacity'],
      bed: json['bed'],
      price: (json['price'] != null) ? json['price'].toDouble() : null,
    );
  }
}
