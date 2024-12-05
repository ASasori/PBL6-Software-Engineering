
import 'package:intl/intl.dart';

class Review {
  final int reviewId;
  final int hotelId;
  final int userId;
  final String? roomType;
  final int rating;
  final String? reviewText;
  final String date;

  Review({
    required this.reviewId,
    required this.hotelId,
    required this.userId,
    this.roomType,
    required this.rating,
    this.reviewText,
    required this.date,});

  factory Review.fromJson(Map<String, dynamic> json) {
    String _parseDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    return Review(
      reviewId: json['id'] ?? 0,
      hotelId: json['hotel'] ?? 0,
      userId: json['user'] ?? 0,
      roomType: json['room_type'],
      rating: json['rating'] ?? 0,
      reviewText: json['review_text'],
      date: _parseDate(json['date']),
    );
  }
}
