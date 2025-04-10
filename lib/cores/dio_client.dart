import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_interceptor.dart';

final Dio dio = Dio(BaseOptions(
  baseUrl: dotenv.env['API_BASE_URL'] ?? '',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
));

void setupDio() {
  dio.interceptors.add(AuthInterceptor(dio: dio));
}
