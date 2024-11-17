// import 'dart:convert';
//
// class Hotel {
//   final int id;
//   final String name;
//   final String description;
//   final String image;
//   final String imageUrl;
//   final String address;
//   final String mobile;
//   final String email;
//   final String status;
//   final int views;
//   final bool featured;
//   final String hid;
//   final String slug;
//   final String date;
//   final int user;
//
//   Hotel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.imageUrl,
//     required this.address,
//     required this.mobile,
//     required this.email,
//     required this.status,
//     required this.views,
//     required this.featured,
//     required this.hid,
//     required this.slug,
//     required this.date,
//     required this.user,
//   });
//
//   // Factory constructor to create a Hotel object from JSON
//   factory Hotel.fromJson(Map<String, dynamic> json) {
//
//     // connect link in order to dowload image from Server
//     // const String baseUrl = 'http://192.168.1.23:8000';
//     // const String baseUrl = 'http://192.168.43.21:8000';
//     // const String baseUrl = 'http://10.10.3.44:8000';
//     const String baseUrl = 'http://192.168.1.4:8000';
//
//     String fullImageUrl ='$baseUrl${json['image']}';
//
//     //remove html card
//     String desc = '${json['description']}';
//     final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
//     desc = desc.replaceAll(regExp, '');
//
//     return Hotel(
//       id: json['id'],
//       name: json['name'],
//       description: desc,
//       image: json['image'],
//       imageUrl: fullImageUrl,
//       address: json['address'],
//       mobile: json['mobile'],
//       email: json['email'],
//       status: json['status'],
//       views: json['views'],
//       featured: json['featured'],
//       hid: json['hid'],
//       slug: json['slug'],
//       date: json['date'],
//       user: json['user'],
//     );
//   }
// }


import 'dart:convert';

class HotelGallery {
  final String id;
  final String imageUrl;

  HotelGallery({
    required this.id,
    required this.imageUrl,
  });

  factory HotelGallery.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'http://192.168.1.11:8000';
    return HotelGallery(
      id: json['hgid'] ?? '', // Sử dụng giá trị mặc định nếu `hgid` bị thiếu
      imageUrl: '$baseUrl${json['image']}', // Thêm baseUrl vào đường dẫn ảnh
    );
  }
}

class Hotel {
  final int id;
  final String name;
  final String description;
  final String? mapImage;
  final String address;
  final String mobile;
  final String email;
  final String status;
  final int views;
  final bool featured;
  final String hid;
  final String slug;
  final String date;
  final int? user;
  final List<String> tags;
  final List<HotelGallery> galleryImages;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    this.mapImage,
    required this.address,
    required this.mobile,
    required this.email,
    required this.status,
    required this.views,
    required this.featured,
    required this.hid,
    required this.slug,
    required this.date,
    this.user,
    required this.tags,
    required this.galleryImages,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'http://192.168.1.11:8000';
    // const String baseUrl = 'http://192.168.1.59:8000';
    // const String baseUrl = 'http://10.10.28.64:8000';


    // URL đầy đủ cho ảnh bản đồ (nếu có)
    String? mapImageUrl = json['map_image'] != null ? '$baseUrl${json['map_image']}' : null;

    // Xóa các thẻ HTML trong mô tả
    String desc = (json['description'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '');

    // Parse danh sách các tag nếu có
    List<String> tagList = (json['tags'] as List<dynamic>?)
        ?.map((tag) => tag.toString())
        .toList() ??
        [];

    // Parse danh sách các hình ảnh từ `HotelGallery`
    List<HotelGallery> galleryImages = (json['galleryImages'] as List<dynamic>?)
        ?.map((item) => HotelGallery.fromJson(item as Map<String, dynamic>))
        .toList() ??
        [];

    return Hotel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: desc,
      mapImage: mapImageUrl,
      address: json['address'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      views: json['views'] ?? 0,
      featured: json['featured'] ?? false,
      hid: json['hid'] ?? '',
      slug: json['slug'] ?? '',
      date: json['date'] ?? '',
      user: json['user'],
      tags: tagList,
      galleryImages: galleryImages,
    );
  }
}
