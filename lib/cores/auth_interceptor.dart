import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final baseUrl = dotenv.env['API_BASE_URL'];
  bool isRefreshing = false;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final isRefreshEndpoint =
        err.requestOptions.path.contains('/token/refresh');
    final hasRetried = err.requestOptions.headers['retry'] == true;

    if (err.response?.statusCode == 401 && !isRefreshEndpoint && !hasRetried) {
      if (isRefreshing) {
        return handler.next(err); // 이미 갱신 중이면 무시
      }

      isRefreshing = true;

      try {
        final refreshToken = prefs.getString('refreshToken');
        final refreshResponse = await dio.post(
          '$baseUrl/token/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = refreshResponse.data['accessToken'];
        await prefs.setString('accessToken', newAccessToken);

        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        retryOptions.headers['retry'] = true;

        final clonedResponse = await dio.fetch(retryOptions);
        return handler.resolve(clonedResponse);
      } catch (refreshError) {
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        print('토큰 갱신 실패. 다시 로그인해야 합니다.');
        return handler.next(err);
      } finally {
        isRefreshing = false;
      }
    }

    handler.next(err);
  }
}
