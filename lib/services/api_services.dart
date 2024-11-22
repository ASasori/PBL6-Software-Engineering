import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/token_manager.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://192.168.1.28:8000';

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (TokenManager.accessToken != null) {
          options.headers['Authorization'] = 'Bearer ${TokenManager.accessToken}';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) {
        return handler.next(error);
      },
    ));
  }
  Dio get dio => _dio;
  String get baseUrl => _baseUrl;
}