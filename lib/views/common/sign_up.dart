import 'package:easy_biz_manager/services/role_service.dart';
import 'package:easy_biz_manager/utility/encryptData.dart';
import 'package:easy_biz_manager/views/common/sign_in.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../mobile/mobile_home.dart';
import 'dart:convert';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController roleCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();


  String selectedRoleValue = "1";
  late List<dynamic>? _roleList = [];
  RoleService roleService = RoleService();
  final _formKey = GlobalKey<FormState>();
  Future<dynamic>? _futureUser;
  UserService userService = UserService();
  var encryptedPwd;
  EncryptDecryptData pwdEncryption = EncryptDecryptData();

  @override
  void initState() {
    super.initState();
    _getRoleList();
  }

  void _getRoleList() async {
    var temp = (await roleService.getRole());
    setState(() {
      _roleList = temp;
    });
    selectedRoleValue = _roleList![0]["id"].toString();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    encryptedPwd = pwdEncryption.encryptPwd(password.text);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
          MobileHomeWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
              //  ListView(
              children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 130,
                width: 400,
              ),
            ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: DropdownButtonFormField(
                    value: selectedRoleValue,
                    //hint: const Text("Select Product"),
                    style: const TextStyle(
                      color: Colors.black54, //<-- SEE HERE
                      fontSize: 16,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRoleValue = newValue!;
                      });
                    },
                    items: _roleList!.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item['role_desc'].toString()),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                     ),

                  ),
                ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: firstName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the first name';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: lastName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your last name';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: contactNo,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact No',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your contact no';
                  }
                  if (value.length > 10 || value.length < 10) {
                    return 'Invalid contact no';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email address';
                  }
                  if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
            ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter address';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: cityCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter city';
                      }
                      return null;
                    },
                  ),
                ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Password is required';
                //   }
                //   return null;
                // },
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            //   child: TextField(
            //     obscureText: true,
            //     controller: password,
            //     decoration: const InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Confirm Password',
            //     ),
            //   ),
            // ),
            Container(
                padding: const EdgeInsets.fromLTRB(110, 10, 110, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minimumSize: const Size(45, 45),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    _submit();
                    setState(() {
                      _futureUser = userService.createUser({
                        "first_name": firstName.text,
                        "last_name": lastName.text,
                        "email": email.text,
                        "username": email.text,
                        "password": encryptedPwd,
                        "contact_no": contactNo.text,
                        "city": cityCtrl.text,
                        "address_no": addressCtrl.text,
                        "street": null,
                        "country": null,
                        "is_active": 1,
                        "is_default_pwd": 1,
                        "role_id": int.parse(selectedRoleValue),
                      });
                    });
                    // if (_futureUser != null  ){
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(const SnackBar(content: Text("User successfully created.")));
                    // }
                    },
                )),
          ])),
    );
  }
}
