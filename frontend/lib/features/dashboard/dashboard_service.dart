import '../../core/api/api_client.dart';

class DashboardService {
  static Future<Map<String, dynamic>> me() async =>
      await ApiClient.instance.get('/api/auth/me') as Map<String, dynamic>;

  static Future<Map<String, dynamic>> overview({String period = 'this_month'}) async =>
      await ApiClient.instance.get('/api/dashboard/overview', query: {'period': period}) as Map<String, dynamic>;

  static Future<Map<String, dynamic>> growth({String range = 'year'}) async =>
      await ApiClient.instance.get('/api/dashboard/growth', query: {'range': range}) as Map<String, dynamic>;

  static Future<List<dynamic>> shipments({int limit = 10}) async {
    final res = await ApiClient.instance.get('/api/shipments', query: {'limit': '$limit'}) as Map<String, dynamic>;
    return res['shipments'] as List<dynamic>;
  }
}