
import 'package:easy_biz_manager/forgot_password.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/common/sign_up.dart';
import 'package:easy_biz_manager/views/web/web_home.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../mobile/mobile_home.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkedValue = false;

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  Future<dynamic>? _futureClient;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
    );
  }

  // bool isValidateLogin(String username, String pwd){
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
     // padding: const EdgeInsets.all(10),
      child: Util.isRunningOnWeb() ? Row(
        children: [
          Expanded(
              child: Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 400,
              )
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(25.0),
                color: Colors.grey[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email/Username',
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Invalid username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Invalid password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordWidget()),
                                );
                              },
                              child: const Text(
                                'Forgot Password',style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        height: 50,
                        width: 250,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.blue, borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          child: const Text('Sign In', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            _submit();

                            // call validate function
                          },
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text('Does not have an account yet?', style: TextStyle(fontSize: 17),),
                    //     TextButton(
                    //       child: const Text(
                    //         'Sign Up',
                    //         style: TextStyle(fontSize: 18, color: Colors.blue),
                    //       ),
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const SignUpWidget()),
                    //         );
                    //       },
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              )
          )
        ],
      ) : ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 400,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email/Username',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Invalid username';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Invalid password';
                  }
                  return null;
                },
              ),
            ),
            // CheckboxListTile(
            //   title: const Text("Remember Me"),
            //   value: checkedValue,
            //   onChanged: (bool? value) {
            //     setState(() {
            //       checkedValue = value!;
            //     });
            //   },
            //   controlAffinity: ListTileControlAffinity.leading,
            // ),
            Container(
                height: 50,
                width: 250,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  child: const Text('Sign In', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    _submit();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
                    // );

                    // call validate function
                  },
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordWidget()),
                    );
                  },
                  child: const Text(
                    'Forgot Password',style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     const Text('Does not have an account yet?', style: TextStyle(fontSize: 17),),
            //     TextButton(
            //       child: const Text(
            //         'Sign Up',
            //         style: TextStyle(fontSize: 18, color: Colors.blue),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => const SignUpWidget()),
            //         );
            //       },
            //     )
            //   ],
            // ),
          ]),
    );
  }
}