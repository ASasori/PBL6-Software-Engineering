import 'package:booking_hotel_app/utils/localfiles.dart';
import 'package:intl/intl.dart';

class Review {
  int? reviewId;
  int? hotelId;
  String? profileImage;
  String? hotelName;
  String? email;
  int? userId;
  String? roomType;
  int? rating;
  String? reviewText;
  String? date;

  Review({
    this.reviewId,
    this.hotelId,
    this.profileImage,
    this.hotelName,
    this.email,
    this.userId,
    this.roomType,
    this.rating,
    this.reviewText,
    this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    String _parseDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }

    return Review(
      reviewId: json['id'] ?? 0,
      hotelId: json['hotel'] ?? 0,
      profileImage: '${Localfiles.baseUrl}${json['profile_image']}',
      hotelName: json['hotel_name'] ?? '',
      email: json['email'] ?? '',
      userId: json['user'] ?? 0,
      roomType: json['room_type'],
      rating: json['rating'] ?? 0,
      reviewText: json['review_text'],
      date: _parseDate(json['date']),
    );
  }
}
