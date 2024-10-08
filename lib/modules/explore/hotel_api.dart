import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/hotel.dart';

// call into api to get list_data_hotel
class listHotels {
  final Dio _dio = Dio();
  Future<List<Hotel>> fetchHotels() async {
    try {
      // final respone = await _dio.get('http://10.10.3.249:8000/api/detail/');
      final respone = await _dio.get('http://192.168.1.23:8000/api/detail/');
      // final respone = await _dio.get('http://192.168.43.21:8000/api/detail/');

      if (respone.statusCode == 200){
        List<dynamic> data = respone.data;
        // convert data fromJson toList Hotel
        return data.map((json)=> Hotel.fromJson(json)).toList();
      }else {
        throw Exception('Failed to load hotels');
      }
    }catch (e){
      print(e);
      throw Exception ('Error fetching data ------ ');
    }
  }
}
class topHotels {
  final Dio _dio = Dio();
  Future<List<Hotel>> fetchHotels() async {
    try {
      // final respone = await _dio.get('http://10.10.3.249:8000/api/detail/');

      final respone = await _dio.get('http://192.168.1.23:8000/api/detail/');
      // final respone = await _dio.get('http://192.168.43.21:8000/api/detail/');
      if (respone.statusCode == 200){
        List<dynamic> data = respone.data;
        // convert data fromJson toList Hotel
        return data.map((json)=> Hotel.fromJson(json)).toList();
      }else {
        throw Exception('Failed to load hotels');
      }
    }catch (e){
      print(e);
      throw Exception ('Error fetching data ------ ');
    }
  }
}