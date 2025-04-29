import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);
  Map<String, dynamic> decodeJWT(String token) {
    return JwtDecoder.decode(token);
  }

  //로그인
  Future<void> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 로그아웃
  Future<void> logout(String refreshToken) async {
    await dio.post(
      '/logout',
      data: {'refreshToken': refreshToken},
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  // User ID값 받아오기
  Future<int> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    //로그인 안했을경우 user_id는 -1을 반환
    if (accessToken == null) return -1;

    final payload = decodeJWT(accessToken);
    final userId = payload['user_id'];
    return userId;
  }

  //회원가입
  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await dio.post('/register', data: {
        'email': email,
        'password': password,
        ' name': name,
      });

      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}
