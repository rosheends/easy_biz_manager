
import 'package:easy_biz_manager/services/executor_service.dart';
import 'package:easy_biz_manager/utility/endpoints/auth.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class AuthService {

  final Map<String, String> _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8"
  };
  final LocalStorage storage = LocalStorage('biz_app');

  Future<bool> login(Map<String, dynamic> params) async {
    final response = await http.post(Uri.parse(Util.getServiceHost() + AuthEndpoints.login), headers: _headers, body: jsonEncode(params));

    if (response.statusCode == 200) {
      storage.setItem("auth_key", response.headers["auth"]);
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }
}