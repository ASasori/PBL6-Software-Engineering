import 'dart:convert';

class Hotel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String imageUrl;
  final String address;
  final String mobile;
  final String email;
  final String status;
  final int views;
  final bool featured;
  final String hid;
  final String slug;
  final String date;
  final int user;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.imageUrl,
    required this.address,
    required this.mobile,
    required this.email,
    required this.status,
    required this.views,
    required this.featured,
    required this.hid,
    required this.slug,
    required this.date,
    required this.user,
  });

  // Factory constructor to create a Hotel object from JSON
  factory Hotel.fromJson(Map<String, dynamic> json) {

    // connect link in order to dowload image from Server
    // const String baseUrl = 'http://192.168.1.23:8000';
    // const String baseUrl = 'http://192.168.43.21:8000';
    // const String baseUrl = "http://10.10.3.249:8000";
    const String baseUrl = "http://192.168.1.11:8000";
    String fullImageUrl  = '$baseUrl${json['image']}';

    //remove html card
    String desc = '${json['description']}';
    final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    desc = desc.replaceAll(regExp, '');

    return Hotel(
      id: json['id'],
      name: json['name'],
      description: desc,
      image: json['image'],
      imageUrl: fullImageUrl,
      address: json['address'],
      mobile: json['mobile'],
      email: json['email'],
      status: json['status'],
      views: json['views'],
      featured: json['featured'],
      hid: json['hid'],
      slug: json['slug'],
      date: json['date'],
      user: json['user'],
    );
  }
}
