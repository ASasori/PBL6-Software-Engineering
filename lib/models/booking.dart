
class BookingData {
  String bookingID;
  String hotelName;
  String imagePath;
  String address;
  DateTime? startDate, endDate;
  int numberOfAdults, numberOfChildren;
  String typeRoom;
  String room;
  double pricePernight;
  double totalAmount;

  BookingData({
    this.bookingID = "",
    this.hotelName = "",
    this.imagePath = "",
    this.address = "",
    this.numberOfAdults = 0,
    this.numberOfChildren = 0,
    this.typeRoom = "",
    this.room = "",
    this.pricePernight = 0,
    this.totalAmount = 0,
    this.startDate,
    this.endDate
  });


}