import 'package:easy_biz_manager/services/project_service.dart';
import 'package:easy_biz_manager/services/role_service.dart';
import 'package:easy_biz_manager/utility/encryptData.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/common/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../app_drawer.dart';
import '../../services/user_service.dart';
import '../mobile/mobile_home.dart';
import 'dart:convert';

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  late Future<List<dynamic>> userList;
  late List<dynamic>? _userList = [];
  late List<dynamic>? _tempUserList = [];
  bool loading = true;
  bool? updatedItem;
  Future<bool>? _response;
  UserService userService = UserService();
  TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _tempUserList = (await userService.getUsers());
    setState(() {
      loading = false;
      _userList = _tempUserList;
    });
  }

  onItemChanged(String value) {
    setState(() {
      _userList = _tempUserList?.where((element) => element['role_desc'].toLowerCase().contains(value.toLowerCase()) ||
          element['first_name'].toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: Util.loggedUser()["role_id"].toString() != "2" ? <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpWidget()),
              );
            },
          )
        ] : <Widget>[
        ],
      ),
      body: loading
          ? Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _textCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search by User Name / User Role',
                    ),
                    onChanged: onItemChanged,
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                  itemCount: _userList!.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      // Step 1
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete),
                      ),
                      onDismissed: (direction) {
                        // Step 2
                        setState(() {
                          _response = userService.deleteUser(_userList![index]);
                          _userList!.removeAt(index);
                        });
                        if (_response != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User successfully deleted')));
                        } else {
                          return;
                        }
                      },
                      child: ListTile(
                        title: Text(_userList![index]['first_name'] +
                            " " +
                            _userList![index]['last_name'] +
                            " (" +
                            _userList![index]['role_desc'] +
                            ")"),
                        subtitle: Text(_userList![index]['email'].toString()),
                        selectedColor: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailUserWidget(user: _userList![index]),
                            ),
                          );
                        },
                        // When a user taps the ListTile, navigate to the DetailScreen.
                        // Notice that you're not only creating a DetailScreen, you're
                        // also passing the current todo through to it.
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ))
              ],
            ),
      drawer: const AppDrawerWidget(),
    );
  }
}

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
  bool? isValid = false;
  // var encryptedPwd;
  // EncryptDecryptData pwdEncryption = EncryptDecryptData();

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
    isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    // encryptedPwd = pwdEncryption.encryptPwd(password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
              //  ListView(
              children: <Widget>[
                // Container(
                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                //   child: Image.asset(
                //     'assets/images/logo.png',
                //     height: 130,
                //     width: 400,
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
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
                      child: const Text('Save', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        _submit();
                        if (isValid == true) {
                          setState(() {
                            _futureUser = userService.createUser({
                              "first_name": firstName.text,
                              "last_name": lastName.text,
                              "email": email.text,
                              "username": email.text,
                              "password": password.text,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserListWidget()),
                          );
                        }

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

// Detail and Edit user functionality
class DetailUserWidget extends StatefulWidget {
  // In the constructor require a Product
  const DetailUserWidget({super.key, required this.user});

  // Declare a field that holds the user
  final dynamic user;

  @override
  State<DetailUserWidget> createState() => _DetailUserWidgetState();
}

class _DetailUserWidgetState extends State<DetailUserWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditModeEnabled = false;
  Future<dynamic>? _updatedProduct;
  UserService userService = UserService();
  RoleService roleService = RoleService();
  ProjectService projectService = ProjectService();
  late List<dynamic>? _roleList = [];
  String? selectedRoleValue;

  TextEditingController roleCtrl = TextEditingController();
  TextEditingController contactNoCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();

  void _getRoleList() async {
    var temp = (await roleService.getRole());
    setState(() {
      _roleList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRoleList();

    roleCtrl.text = widget.user["role_desc"].toString();
    contactNoCtrl.text = widget.user["contact_no"].toString();
    emailCtrl.text = widget.user["email"].toString();
    addressCtrl.text = widget.user["address_no"].toString();
    cityCtrl.text = widget.user["city"].toString();

    //start listening to changes
    roleCtrl.addListener(() {
      setState(() {
        if (roleCtrl.text != widget.user["role_id"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    contactNoCtrl.addListener(() {
      setState(() {
        if (contactNoCtrl.text != widget.user["contact_no"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    emailCtrl.addListener(() {
      setState(() {
        if (emailCtrl.text != widget.user["email"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    addressCtrl.addListener(() {
      setState(() {
        if (addressCtrl.text != widget.user["address_no"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    cityCtrl.addListener(() {
      setState(() {
        if (cityCtrl.text != widget.user["city"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    roleCtrl.dispose();
    contactNoCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Product to create the UI.
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                widget.user["first_name"] + " " + widget.user["last_name"]),
          ),
          body: Form(
            child: ListView(
              //  ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: DropdownButtonFormField(
                    value: widget.user["role_id"].toString(),
                    //hint: const Text("Select Product"),
                    style: const TextStyle(
                      color: Colors.black54, //<-- SEE HERE
                      fontSize: 16,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (widget.user["role_id"] != newValue) {
                          widget.user["role_id"] = newValue!;
                          _isEditModeEnabled = true;
                        }
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
                      labelText: 'User Role',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: contactNoCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact No',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.user["contact_no"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.user["email"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.user["address_no"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: cityCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.user["city"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        // minimumSize: Size(50, 50);
                      ),
                      onPressed: _isEditModeEnabled
                          ? () {
                              setState(() {
                                _updatedProduct = userService.updateUser({
                                  "email": emailCtrl.text,
                                  "username": emailCtrl.text,
                                  "contact_no": contactNoCtrl.text,
                                  "city": cityCtrl.text,
                                  "address_no": addressCtrl.text,
                                  "street": null,
                                  "country": null,
                                  "is_active": 1,
                                  "is_default_pwd": 1,
                                  "role_id": widget.user["role_id"],
                                  "id": widget.user["id"],
                                });
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserListWidget()),
                              );
                            }
                          : null,
                      child: const Text('Save'),
                    )),
              ],
            ),
          ),
        ));
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear)),
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
          child: Text(
        query,
        style: const TextStyle(fontSize: 64),
      ));

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile();
  }
}
