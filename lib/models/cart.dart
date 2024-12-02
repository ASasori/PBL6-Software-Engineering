import 'package:intl/intl.dart';

class CartItem {
  final int cartItemId;
  final int cartId;
  final int roomId;
  final String roomType;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numAdults;
  final int numChildren;
  final int quantity;
  final double price;

  CartItem({
    required this.cartItemId,
    required this.cartId,
    required this.roomId,
    required this.roomType,
    this.checkInDate,
    this.checkOutDate,
    required this.numAdults,
    required this.numChildren,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    String roomType = json['room'] != null && json['room']['room_type'] != null
        ? json['room']['room_type']['type'] ?? "No Room Type"
        : "No Room Type";

    return CartItem(
      cartItemId: json['id'] ?? '',
      cartId: json['cart'] ?? '',
      roomId: json['room'] ?? '',
      roomType: roomType,
      checkInDate: json['check_in_date'] != null
          ? DateTime.parse(json['check_in_date'])
          : null,
      checkOutDate: json['check_out_date'] != null
          ? DateTime.parse(json['check_out_date'])
          : null,
      numAdults: json['num_adults'] ?? 1,
      numChildren: json['num_children'] ?? 0,
      quantity: json['quantity'] ?? 1,
      price: json['room']['price']?.toDouble() ?? 0.0,
    );
  }

  double totalPrice() {
    return price * quantity;
  }

  int totalCartItem() {
    return quantity;
  }

  @override
  String toString() {
    return "$quantity x $roomType in cart";
  }
}

class Cart {
  final int cartId;
  final int userId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CartItem> cartItems;

  Cart({
    required this.cartId,
    required this.userId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.cartItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> cartItems = (json['cart_items'] as List<dynamic>?)
        ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];

    return Cart(
      cartId: json['cart_id'] ?? '',
      userId: json['user_id'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      cartItems: cartItems,
    );
  }

  double totalPrice() {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice());
  }

  int totalCartItem() {
    return cartItems.fold(0, (sum, item) => sum + item.totalCartItem());
  }

  @override
  String toString() {
    return "Cart of $userId with ${cartItems.length} items";
  }
}


