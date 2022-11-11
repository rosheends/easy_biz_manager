
import 'package:easy_biz_manager/forgot_password.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/common/sign_up.dart';
import 'package:easy_biz_manager/views/web/web_home.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email/Username',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
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
                            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          child: const Text('Sign In', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
                            );

                            // call validate function
                          },
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have an account yet?', style: TextStyle(fontSize: 17),),
                        TextButton(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpWidget()),
                            );
                          },
                        )
                      ],
                    ),
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
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email/Username',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            CheckboxListTile(
              title: const Text("Remember Me"),
              value: checkedValue,
              onChanged: (bool? value) {
                setState(() {
                  checkedValue = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Container(
                height: 50,
                width: 250,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  child: const Text('Sign In', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Util.isRunningOnWeb() ? WebHomeWidget() : MobileHomeWidget()),
                    );

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have an account yet?', style: TextStyle(fontSize: 17),),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpWidget()),
                    );
                  },
                )
              ],
            ),
          ]),
    );
  }
}