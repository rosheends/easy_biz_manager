import 'package:easy_biz_manager/manage_projects.dart';
import 'package:easy_biz_manager/services/assign_users_service.dart';
import 'package:easy_biz_manager/services/user_service.dart';
import 'package:easy_biz_manager/utility/endpoints/assignedUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart' as constants;
import 'package:flutter_checkbox_dialog/flutter_checkbox_dialog.dart';

class AssignProjects extends StatefulWidget {
  const AssignProjects({super.key, required this.id});

  final String id;

  @override
  State<AssignProjects> createState() => _AssignProjectsState();
}

class _AssignProjectsState extends State<AssignProjects> {
  bool loading = true;
  late List<dynamic> _assignedUserList = [];
  late List<dynamic> _tempAssignedUserList = [];
  final AssignUserService _assignedUserService = AssignUserService();
  Future<bool>? _response;
  var checkboxValue = false;
  TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAssignedUserList();
  }

  void _getAssignedUserList() async {
    _tempAssignedUserList =
        (await _assignedUserService.getAssignedUsers(widget.id));
    setState(() {
      loading = false;
      if (_tempAssignedUserList != null) {
        _assignedUserList = _tempAssignedUserList;
      }
    });
  }

  onItemChanged(String value) {
    setState(() {
      _assignedUserList = _tempAssignedUserList.where((element) => element['role_desc'].toLowerCase().contains(value.toLowerCase()) ||
          element['first_name'].toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Users'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AddProjectAssignment(assignedUserList: _assignedUserList, projId: widget.id),
              )
                );
            },
          ),
        ],
      ),
      body: loading
          ? Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ):Column(children: <Widget>[
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
              itemCount: _assignedUserList.length,
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
                      _response = delete(
                          _assignedUserList[index]["project_id"].toString(),
                          _assignedUserList[index]["user_id"].toString());
                      _assignedUserList.removeAt(index);
                    });
                    if (_response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('User unassigned from this project')));
                    } else {
                      return;
                    }
                  },
                  child: ListTile(
                    title: Text(_assignedUserList[index]['first_name'] +
                        " " +
                        _assignedUserList[index]['last_name']),
                    subtitle: Text(
                        _assignedUserList[index]['email'].toString() +
                            "\nRole: " +
                            _assignedUserList[index]['role_desc'].toString()),
                    selectedColor: Colors.blueAccent,
                    onTap: () {},
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
            )),
      ]
    ),
      // drawer: const AppDrawerWidget(),
    );
  }
}

  Future<bool> delete(String projectId, String userId) async {
    final response = await http.delete(
      Uri.parse('${constants.URI}assignedUser/$projectId/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

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


class AddProjectAssignment extends StatefulWidget {
  const AddProjectAssignment({super.key, required this.assignedUserList, required this.projId});

  final List<dynamic> assignedUserList;
  final dynamic projId;

  @override
  State<AddProjectAssignment> createState() => _AddProjectAssignmentState();
}

class _AddProjectAssignmentState extends State<AddProjectAssignment> {
  bool loading = true;
  final AssignUserService _assignedUserService = AssignUserService();
  Future<bool>? _response;
  bool _isChecked = false;
  late List<dynamic>? _userList = [];
  late List<dynamic>? _assignedList = [];
  late List<dynamic>? _unAssignedUserList = [];
  UserService userService = UserService();
  late Map<String, bool> userArr;
  Future<dynamic>? _futureAssignment;
  AssignUserService assignService = AssignUserService();


  @override
  void initState() {
    super.initState();
    _assignedList = widget.assignedUserList;
    _getData();
  }

  void _getData() async {
    _userList = (await userService.getUsers());
    _userList?.forEach((element) {
      element["selected"] = false;

      bool isUserFound = false;

      _assignedList?.forEach((userElement) {
        if(userElement["user_id"] == element["id"]){
          isUserFound = true;
        }

      });

      if(!isUserFound){
        _unAssignedUserList?.add(element);
      }

    });

    setState(() {
      loading = false;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageProjectWidget(),
                    )
                );
              },
            ),
          ],
        ),
        body: Form(
            child: ListView.builder(
          itemCount: _unAssignedUserList!.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(_unAssignedUserList![index]["email"].toString()),
              subtitle: Text(_unAssignedUserList![index]["role_desc"].toString()),
              value: _unAssignedUserList![index]["selected"],
              onChanged: (bool? value) {
                setState(() {
                  _unAssignedUserList![index]["selected"] = value;
                  print(_unAssignedUserList![index]["selected"].toString());

                  if (_unAssignedUserList![index]["selected"] == true){
                    _futureAssignment = assignService.createAssignment({
                      "project_id": widget.projId.toString(),
                      "user_id": _unAssignedUserList![index]["id"].toString(),
                    });
                  }else if (_unAssignedUserList![index]["selected"]== false){
                    _response = delete(
                        widget.projId.toString(),
                        _unAssignedUserList![index]["id"].toString());
                  }
                });
              },
            );
          },
        ),
        ));
  }

  Future<bool> delete(String projectId, String userId) async {
    final response = await http.delete(
      Uri.parse('${constants.URI}assignedUser/$projectId/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

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
