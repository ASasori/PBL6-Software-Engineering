class ImageLocation {
  String imagePath;
  ImageLocation({required this.imagePath});

  factory ImageLocation.fromJson(Map<String, dynamic> json){
    // String baseUrl = 'http://192.168.1.23:8000';
    String baseUrl = 'http://192.168.43.21:8000';
    // String baseUrl = 'http://192.168.1.16:8000';
    String fullImagePath = '$baseUrl${json['imagePath']}';
    return ImageLocation(imagePath: fullImagePath,);
  }
}
class Location {
  final String location;
  final List<ImageLocation> imageLocationList;

  Location ({required this.location, required this.imageLocationList});

  factory Location.fromJson (Map<String, dynamic> json){
    var list = json['imageLocationList'] as List;
    List<ImageLocation> imageList = list.map((i) => ImageLocation.fromJson(i)).toList();

    return Location (
      location: json['location'],
      imageLocationList: imageList,
    );
  }
}