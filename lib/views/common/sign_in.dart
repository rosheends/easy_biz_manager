
import 'package:easy_biz_manager/forgot_password.dart';
import 'package:easy_biz_manager/services/authentication_service.dart';
import 'package:easy_biz_manager/services/user_service.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/web/web_home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';

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
  AuthService authService = AuthService();
  UserService userService = UserService();

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  Future<dynamic>? _futureClient;
  bool isValid = false;

  void _submit() {

    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }

    authService.login({
      "username" : nameController.text,
      "password" : passwordController.text
    }).then((value) async => {

      if(value){
        _formKey.currentState?.save(),
        // if((await userService.getUser(Util.loggedUser()['id'].toString()))["is_default_pwd"] == 1){
        //   openDialog()
        // } else {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
          )
       // },
      } else {
        Fluttertoast.showToast(
            msg: "Invalid user credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            webBgColor: "linear-gradient(to right, #e55151, #e55151)",
            webPosition: "right",
        )
      }
    });

  }

  Future openDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: TextField(
          decoration: InputDecoration(hintText: 'New password'),
        ),
        actions: [
          TextButton(onPressed: () async {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
            );
          }, child: Text('SUBMIT'))
        ],
      ),
  );

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
                            return 'Enter a valid username';
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
                            return 'Enter a valid password';
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

                            if (isValid){
                              openDialog();
                            }

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
                    return 'Enter a valid username';
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
                    return 'Enter a valid password';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  child: const Text('Sign In', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    _submit();

                    if (isValid){
                      openDialog();
                    }

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