
import 'package:easy_biz_manager/views/common/sign_in.dart';
import 'package:flutter/material.dart';

class BizManager extends StatelessWidget {
  const BizManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Scaffold(
        body: SignInWidget(),
      ),
    );
  }
}