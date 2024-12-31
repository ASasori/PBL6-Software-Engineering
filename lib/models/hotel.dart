class HotelGallery {
  String imageUrl;

  HotelGallery({
    required this.imageUrl,
  });

  factory HotelGallery.fromJson(Map<String, dynamic> json) {
    return HotelGallery(
      imageUrl: json['image'] ?? '',
    );
  }
}

class Hotel {
  String name;
  String description;
  String? mapImage;
  String address;
  String mobile;
  String email;
  String status;
  int views;
  bool featured;
  String hid;
  String slug;
  String date;
  int user;
  double averageRating;
  double priceMin;
  double priceMax;
  List<String> tags;
  List<HotelGallery> galleryImages;
  int reviewCount;

  Hotel({
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
    required this.user,
    this.averageRating = 0.0,
    required this.tags,
    required this.galleryImages,
    this.reviewCount = 0,
    this.priceMax = 0.0,
    this.priceMin = 0.0,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    String desc = (json['description'] ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .trim();

    List<String> tagList = (json['tags'] as List<dynamic>?)
        ?.map((tag) => tag.toString())
        .toList() ??
        [];

    List<HotelGallery> galleryImages = (json['hotel_gallery'] as List<dynamic>?)
        ?.map((item) =>
        HotelGallery.fromJson(item as Map<String, dynamic>))
        .toList() ??
        [];

    return Hotel(
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
      user: json['user'] ?? 0,
      priceMin: (json['price_min'] ?? 0.0) as double,
      priceMax: (json['price_max'] ?? 0.0) as double,
      averageRating: (json['average_rating'] ?? 0.0) as double,
      tags: tagList,
      galleryImages: galleryImages,
      reviewCount: json['review_count'] ?? 0,
    );
  }
}
