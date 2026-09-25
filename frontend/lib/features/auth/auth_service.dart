import '../../core/api/api_client.dart';

class AuthService {
  static Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await ApiClient.instance.post('/api/auth/register', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    });
    await ApiClient.instance.setToken(res['token']);
  }

  static Future<void> login({required String email, required String password}) async {
    final res = await ApiClient.instance.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    await ApiClient.instance.setToken(res['token']);
  }

  static Future<void> logout() async {
    await ApiClient.instance.setToken(null);
  }
}