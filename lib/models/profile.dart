import 'package:intl/intl.dart';

import '../app_config.dart';

class Profile {
  String? fullName;
  String? image;
  String? phone;
  String? gender;
  String? country;
  String? city;
  String? state;
  String? address;
  String? identityType;
  String? identityImage;
  double? wallet;
  bool? verified;
  String? date;

  Profile({
    this.fullName,
    this.image,
    this.phone,
    this.gender,
    this.country,
    this.city,
    this.state,
    this.address,
    this.identityType,
    this.identityImage,
    this.wallet,
    this.verified,
    this.date,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    String _parseDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }

    return Profile(
      fullName: json['full_name'] ?? '',
      image: '${AppConfig.baseUrl}${json['image']}',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      identityType: json['indentity_type'],
      identityImage: '${AppConfig.baseUrl}${json['indentity_image']}',
      wallet: (json['wallet'] as num?)?.toDouble() ?? 0.0,
      verified: json['verified'] ?? false,
      date: json['date'] != null ? _parseDate(json['date']) : null,
    );
  }
}
