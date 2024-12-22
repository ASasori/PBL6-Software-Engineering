
class HotelGallery {
  final String imageUrl;

  HotelGallery({
    required this.imageUrl,
  });

  factory HotelGallery.fromJson(Map<String, dynamic> json) {

    return HotelGallery(
      imageUrl: '${json['image']}',
    );
  }
}

class Hotel {
  // final int? hotelId;
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
    // this.hotelId,
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

    String desc = (json['description'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '');

    List<String> tagList = (json['tags'] as List<dynamic>?)
        ?.map((tag) => tag.toString())
        .toList() ??
        [];

    List<HotelGallery> galleryImages = (json['hotel_gallery'] as List<dynamic>?)
        ?.map((item) => HotelGallery.fromJson(item as Map<String, dynamic>))
        .toList() ??
        [];

    return Hotel(
      // hotelId: json['id'] ?? '',
      name: json['name'] ?? '',
      description: desc,
      mapImage: json['map_image'],
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
