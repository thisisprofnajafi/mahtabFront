import 'package:bot/utils/AccessToken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiUtil {
  static const String baseUrl =
      'https://abolfazlnajafi.com/mahtab/public/api'; // Update the base URL

  static Future<String?> accessToken = AccessTokenUtil.readAccessToken();

  static Future<String?> bearerToken = AccessTokenUtil.readAccessToken();

  static Future<Map<String, String>> getHeaders() async {
    final token = await accessToken;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> getRequest(String endpoint) async {
    print('$baseUrl/$endpoint');
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
    return _processResponse(response);
  }

  static Future<dynamic> postRequest(String endpoint, dynamic data) async {

    final headers = await getHeaders();
    print('Headers: $headers');
    print('Data: ${json.encode(data)}');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: json.encode(data),
      headers: headers,
    );
    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please check your credentials.');
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static void logRequest(String method, String endpoint, dynamic data) {
    print('API Request:');
    print('Method: $method');
    print('Endpoint: $endpoint');
    print('Data: $data');
  }

  static void logResponse(http.Response response) {
    print('API Response:');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
  }
}
