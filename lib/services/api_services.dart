import 'package:dio/dio.dart';
import 'package:booking_hotel_app/models/token_manager.dart';

import '../app_config.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = AppConfig.baseUrl;

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