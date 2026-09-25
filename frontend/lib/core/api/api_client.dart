import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  @override
  String toString() => message;
}

class RetryStatus {
  final int attempt; // the attempt that just failed
  final int maxAttempts;
  const RetryStatus(this.attempt, this.maxAttempts);
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const int maxAttempts = 6;
  static const Duration requestTimeout = Duration(seconds: 15);
  static const Duration retryDelay = Duration(seconds: 5);

  /// The UI listens to this to show the "waking up the server" banner.
  final ValueNotifier<RetryStatus?> retryStatus = ValueNotifier(null);

  String? _token;
  bool get hasToken => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('token');
    } else {
      await prefs.setString('token', token);
    }
  }

  /// Silent ping so Render wakes up while the user is still on the page.
  Future<void> warmUp() async {
    try {
      await http
          .get(Uri.parse('${Config.apiUrl}/health'))
          .timeout(const Duration(seconds: 90));
    } catch (_) {}
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send('POST', path, body: body);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${Config.apiUrl}$path').replace(queryParameters: query);
    final headers = {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = method == 'GET'
            ? await http.get(uri, headers: headers).timeout(requestTimeout)
            : await http
                .post(uri, headers: headers, body: jsonEncode(body))
                .timeout(requestTimeout);

        if ([502, 503, 504].contains(response.statusCode)) {
          throw Exception('Server not ready');
        }

        final result = _handle(response);
        retryStatus.value = null;
        return result;
      } on ApiException {
        // Real API errors (400, 401, 409...) are never retried.
        retryStatus.value = null;
        rethrow;
      } catch (_) {
        // Network error, timeout, gateway error, or non-JSON wake-up page.
        if (attempt == maxAttempts) {
          retryStatus.value = null;
          throw ApiException('Could not reach the server. Please try again.');
        }
        retryStatus.value = RetryStatus(attempt, maxAttempts);
        await Future.delayed(retryDelay);
      }
    }
  }

  dynamic _handle(http.Response r) {
    final body = r.body.isEmpty ? null : jsonDecode(r.body);
    if (r.statusCode >= 200 && r.statusCode < 300) return body;

    final fieldErrors = <String, String>{};
    if (body is Map && body['errors'] is Map) {
      (body['errors'] as Map).forEach((k, v) => fieldErrors[k.toString()] = v.toString());
    }
    throw ApiException(
      body is Map ? (body['message'] ?? 'Request failed').toString() : 'Request failed',
      statusCode: r.statusCode,
      fieldErrors: fieldErrors,
    );
  }
}