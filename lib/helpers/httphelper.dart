import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcdo_ui/models/item-category.dart';

class HttpClientHelper {
  final String baseUrl = "http://localhost:5000/orders";

  Future<http.Response> httpGet(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(response);
  }

  Future<http.Response> httpPost(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  Future<http.Response> httpPut(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  Future<http.Response> httpDelete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(response);
  }

  http.Response _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<List<ItemCategory>> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/GetMenu'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => ItemCategory.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print(e);
    }

    return [];
  }
}
