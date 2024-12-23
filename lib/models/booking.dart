class BookingData {
  int id;
  String bookingID;
  String hotelName;
  String imagePath;
  String address;
  String email;
  String phone;
  String fullName;
  DateTime? startDate, endDate;
  bool checkedIn, checkedOut, checkedInTracker, checkedOutTracker, isActive;
  int numberOfAdults, numberOfChildren;
  String roomType;
  String room;
  double pricePernight;
  double? totalAmount;
  double saved;
  int totalDays;

  BookingData({
    this.id = 0,
    this.bookingID = "",
    this.hotelName = "",
    this.imagePath = "",
    this.address = "",
    this.email = "",
    this.phone = "",
    this.fullName = "",
    this.checkedIn = false,
    this.checkedOut = false,
    this.checkedInTracker = false,
    this.checkedOutTracker = false,
    this.isActive = true,
    this.numberOfAdults = 0,
    this.numberOfChildren = 0,
    this.roomType = "",
    this.room = "",
    this.pricePernight = 0,
    this.totalAmount,
    this.saved = 0, 
    this.startDate,
    this.endDate,
    this.totalDays = 0,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'] ?? 0,
      bookingID: json['booking_id'] ?? "",
      hotelName: json['hotel_name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      fullName: json['full_name'] ?? "",
      startDate: json['check_in_date'] != null
          ? DateTime.parse(json['check_in_date'])
          : null,
      endDate: json['check_out_date'] != null
          ? DateTime.parse(json['check_out_date'])
          : null,
      totalDays: json['total_days'] ?? 0,
      checkedIn: json['checked_in'] ?? false,
      checkedOut: json['checked_out'] ?? false,
      checkedInTracker: json['checked_in_tracker'] ?? false,
      checkedOutTracker: json['checked_out_tracker'] ?? false,
      isActive: json['is_active'] ?? true,
      numberOfAdults: json['num_adults'] ?? 0,
      numberOfChildren: json['num_children'] ?? 0,
      roomType: json['room_type_name'] ?? "",
      room: json['room'] != null && (json['room'] as List).isNotEmpty
          ? json['room'][0].toString()
          : "",
      pricePernight: (json['before_discount'] != null
          ? double.tryParse(json['before_discount'])
          : 0.0) ??
          0.0,
      totalAmount: json['total'] != null
          ? double.tryParse(json['total'])
          : null,
      saved: (json['saved'] != null
          ? double.tryParse(json['saved'])
          : 0.0) ??
          0.0,
    );
  }
}
