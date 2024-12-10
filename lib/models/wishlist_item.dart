class WishlistItem {
  final int hotelId;
  final String hotelName;
  final String address;
  final String imageUrl;
  final int itemCartId;
  final DateTime startDate;
  final DateTime endDate;
  final String typeRoom;
  final double pricePernight;
  final double totalAmount;
  final int? adult;
  final int? children;

  WishlistItem({
    required this.hotelId,
    required this.hotelName,
    required this.address,
    required this.imageUrl,
    required this.itemCartId,
    required this.startDate,
    required this.endDate,
    required this.typeRoom,
    required this.pricePernight,
    required this.totalAmount,
    this.adult,
    this.children,
  });
}