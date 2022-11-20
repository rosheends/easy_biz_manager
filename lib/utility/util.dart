
import 'package:easy_biz_manager/utility/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

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
}