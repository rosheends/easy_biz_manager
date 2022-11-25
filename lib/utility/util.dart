
import 'package:easy_biz_manager/utility/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';

class Util {
  /// To check the running platform is web
  static bool isRunningOnWeb(){
    return kIsWeb;
  }

  /// Get service host
  static String getServiceHost(){
    return Constants.serviceHost + Constants.serviceBasePath;
  }

  /// Push Routing function
  static routeNavigatorPush(BuildContext context, Widget mobile, Widget web){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => isRunningOnWeb() ? web : mobile),
    );
  }

  /// Print amount
  static String printAmount(double amount){
    return NumberFormat.simpleCurrency(
        name: 'LKR',
        decimalDigits: 2,
    ).format(amount);
  }

  /// getLogged User
  static String loggedUser(){
    final LocalStorage storage = LocalStorage('biz_app');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(storage.getItem("auth_key"));
    return decodedToken["email"];
  }
}