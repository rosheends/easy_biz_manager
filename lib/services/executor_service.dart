import 'dart:convert';

import 'package:http/http.dart' as http;

class ExecutorService {
  final Map<String, String> _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> params) async {
    final response = await http.post(Uri.parse(url), headers: _headers, body: jsonEncode(params));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create object');
    }
  }

  // Update product service call
  Future<dynamic> put(String url, Map<String, dynamic> params) async {
    final response = await http.put(Uri.parse(url.replaceAll("{id}", params['id'].toString())), headers: _headers, body: jsonEncode(params));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create object');
    }
  }

  // Delete product service call
  Future<bool> delete(String url, Map<String, dynamic> params) async {
    final response = await http.delete(Uri.parse(url.replaceAll("{id}", params['id'].toString())), headers: _headers, body: jsonEncode(params));

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return false;
    }
  }
}


