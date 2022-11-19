import 'dart:convert';
import 'package:easy_biz_manager/utility/constants.dart';
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:http/http.dart' as http;
import 'views/mobile/mobile_home.dart';
import 'constant.dart' as constants;

// Class to map with database object
class Project {
  final String projectName;
  final String description;

  Project(this.projectName, this.description);
  factory Project.fromMap(Map<String, dynamic> json) {
    return Project(
      json['project_name'],
      json['description'],
    );
  }
}

List<Project> parseProject(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Project>((json) => Project.fromMap(json)).toList();
}

Future<List<Project>> fetchProductList() async {
  final response = await http.get(
      Uri.parse('${constants.URI}project/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Project.fromMap(jsonDecode(response.body));
    return parseProject(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load projects');
  }
}

class ManageProjectWidget extends StatefulWidget {
  const ManageProjectWidget({super.key});

  @override
  State<ManageProjectWidget> createState() => _ManageProjectWidgetState();
}

class _ManageProjectWidgetState extends State<ManageProjectWidget> {
  late Future<List<Project>> projectList;
  late List<Project>? _projectList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //projectList = fetchProductList();
    _getData();
  }

  void _getData() async {
    _projectList = (await fetchProductList());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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
                    builder: (context) => const AddProjectWidget()),
              );
            },
          )
        ],
      ),
      body: Center(
          child: loading == true
              ? const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  itemCount: _projectList!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shadowColor: Colors.blue,
                      margin: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            //Center Column contents vertically,
                            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                            //mainAxisAlignment: MainAxisAlignment. center,
                            children: [
                              Container(
                                width: 120,
                              child: Text(
                                _projectList![index].projectName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              ),
                              Text(
                                _projectList![index].description,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    );
                  })),
      drawer: const AppDrawerWidget(),
    );
  }
}

// Add Project functionality
class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({Key? key}) : super(key: key);

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  TextEditingController projectName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController timeBudget = TextEditingController();

  // sample values
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuProductItems = [
      const DropdownMenuItem(value: "C001", child: Text("Supply Chain")),
      const DropdownMenuItem(value: "C002", child: Text("Finance"))
    ];
    return menuProductItems;
  }

  // sample values
  List<DropdownMenuItem<String>> get dropdownClientItems {
    List<DropdownMenuItem<String>> menuClientItems = [
      const DropdownMenuItem(value: "C001", child: Text("Singer")),
      const DropdownMenuItem(value: "C002", child: Text("Softlogic"))
    ];
    return menuClientItems;
  }

  String? selectedProductValue;
  String? selectedClientValue;
  Future<Project>? _futureProject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: Form(
          child: ListView(
              //  ListView(
              children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: DropdownButtonFormField(
                  value: selectedProductValue,
                  //hint: const Text("Select Product"),
                  style: const TextStyle(
                    color: Colors.black54, //<-- SEE HERE
                    fontSize: 16,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProductValue = newValue!;
                    });
                  },
                  items: dropdownItems,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Select Product',
                  border: OutlineInputBorder(),
                ),),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                  value: selectedClientValue,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedClientValue = newValue!;
                    });
                  },
                  items: dropdownClientItems,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Select Client',
                  border: OutlineInputBorder(),
                ),),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: projectName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Code',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Name',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: timeBudget,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Time Budget',
                ),
                style: const TextStyle(fontSize: 16),
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
                      minimumSize: const Size(50, 50),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      setState(() {
                        _futureProject = createProject(projectName.text, description.text);

                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileHomeWidget()),
                      );
                    })),
          ])),
    );
  }
}

// Future<http.Response> createClient(String projectCode, description) {
//   return http.post(
//     Uri.parse('http://172.23.112.1:8080/api/v1/management/project/'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'project_name': projectCode,
//       'description': description,
//     }),
//   );
// }

Future<Project> createProject(String projectCode, description) async {
  final response = await http.post(
    Uri.parse('${constants.URI}project/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'project_name': projectCode,
       'description': description,
      //'project_code': prject
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Project.fromMap(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create project.');
  }
}
