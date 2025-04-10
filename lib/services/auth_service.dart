import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_BASE_URL', // Replace with your actual API base URL
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // 토큰 갱신 중복 방지를 위한 플래그
  bool _isRefreshing = false;
  // 토큰 갱신 대기열
  final List<Completer<void>> _refreshQueue = [];

  // 토큰 저장
  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_userIdKey, userId);
  }

  // 토큰 삭제
  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
  }

  // 로그인
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        await _saveTokens(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
          userId: response.data['userId'],
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // 토큰 갱신
  Future<bool> refreshToken() async {
    // 이미 갱신 중이면 대기열에 추가
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      await completer.future;
      return true;
    }

    try {
      _isRefreshing = true;
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) {
        _handleRefreshFailure();
        return false;
      }

      final response = await _dio.post('/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        await _saveTokens(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
          userId: response.data['userId'],
        );
        _handleRefreshSuccess();
        return true;
      }

      _handleRefreshFailure();
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      _handleRefreshFailure();
      return false;
    }
  }

  // 토큰 갱신 성공 처리
  void _handleRefreshSuccess() {
    _isRefreshing = false;
    // 대기 중인 모든 요청 완료 처리
    for (var completer in _refreshQueue) {
      completer.complete();
    }
    _refreshQueue.clear();
  }

  // 토큰 갱신 실패 처리
  void _handleRefreshFailure() {
    _isRefreshing = false;
    // 대기 중인 모든 요청 실패 처리
    for (var completer in _refreshQueue) {
      completer.completeError('Token refresh failed');
    }
    _refreshQueue.clear();
    // 토큰 삭제
    _clearTokens();
  }

  // 로그아웃
  Future<void> logout() async {
    await _clearTokens();
  }

  // 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey) != null;
  }

  // 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // 리프레시 토큰 가져오기
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });

      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}
