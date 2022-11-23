import 'package:easy_biz_manager/services/product_service.dart';
import 'package:easy_biz_manager/services/project_service.dart';
import 'package:easy_biz_manager/views/mobile/mobile_home.dart';
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:http/http.dart' as http;
import 'constant.dart' as constants;

// Class to map with database object
// class Project {
//   final int projectId;
//   final String projectCode;
//   final String projectName;
//   final String description;
//   final String budget;
//
//   Project(this.projectId, this.projectCode, this.projectName, this.description, this.budget);
//   factory Project.fromMap(Map<String, dynamic> json) {
//     return Project(
//       json['project_id'],
//       json['project_code'],
//       json['project_name'],
//       json['description'],
//       json['budget'],
//     );
//   }
// }

// List<dynamic> parseProject(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<dynamic>((json) => Project.fromMap(json)).toList();
// }

class ManageProjectWidget extends StatefulWidget {
  const ManageProjectWidget({super.key});

  @override
  State<ManageProjectWidget> createState() => _ManageProjectWidgetState();
}

class _ManageProjectWidgetState extends State<ManageProjectWidget> {
  late Future<List<dynamic>> projectList;
  late List<dynamic>? _projectList = [];
  bool loading = true;
  Future<dynamic>? updatedItem;
  Future<bool>? _response;
  ProjectService projService = ProjectService();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _projectList = (await projService.getProjects());
    setState(() {
      loading = false;
    });
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
      body: loading
          ? Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.separated(
              itemCount: _projectList!.length,
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
                      _projectList!.removeAt(index);
                      updatedItem =
                          projService.deleteProject(_projectList![index]);
                    });
                    if (_projectList![index]['is_active'] == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${_projectList![index]} successfully deleted')));
                    } else {
                      return;
                    }
                  },
                  child: ListTile(
                    title: Text(_projectList![index]['project_code']),
                    subtitle: Text(_projectList![index]['project_code'] +
                        " - " +
                        _projectList![index]['description']),
                    selectedColor: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProjectWidget(
                              project: _projectList![index]),
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
            ),
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
  TextEditingController projectCodeCtrl = TextEditingController();
  TextEditingController projectNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController timeBudgetCtrl = TextEditingController();

  ProductService prodService = ProductService();
  ProjectService projService = ProjectService();
  late List<dynamic>? _productList = [];

  @override
  void initState() {
    super.initState();
    _getProductData();

    projectCodeCtrl.addListener(() {
      setState(() {
        _isBtnEnabled = false;
      });
    });
  }

  void _getProductData() async {
    var temp = (await prodService.getProducts());
    setState(() {
      _productList = temp;
    });
  }

  // sample values
  List<DropdownMenuItem<String>> get dropdownProductItems {
    List<DropdownMenuItem<String>> menuProductItems = [
      const DropdownMenuItem(value: "C001", child: Text("Supply Chain")),
      const DropdownMenuItem(value: "C002", child: Text("Finance"))
    ];
    return menuProductItems;
  }

  // sample values
  // List<DropdownMenuItem<String>> get dropdownClientItems {
  //   List<DropdownMenuItem<String>> menuClientItems = [
  //     const DropdownMenuItem(value: "C001", child: Text("Singer")),
  //     const DropdownMenuItem(value: "C002", child: Text("Softlogic"))
  //   ];
  //   return menuClientItems;
  // }

  String? selectedProductValue;
  String? selectedClientValue;
  Future<dynamic>? _futureProject;
  bool _isBtnEnabled = false;

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
              child: TextField(
                controller: projectCodeCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Code *',
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (text) {
                  if (projectCodeCtrl.text.isNotEmpty &&
                      selectedProductValue != null) {
                    _isBtnEnabled = true;
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
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
                    if (projectCodeCtrl.text.isNotEmpty &&
                        selectedProductValue != null) {
                      _isBtnEnabled = true;
                    }
                  });
                },
                items: _productList!.map((item) {
                  return DropdownMenuItem(
                    child: new Text(item['product_code'].toString()),
                    value: item['product_code'].toString(),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Select Product',
                  border: OutlineInputBorder(),
                ),
              ),
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
                items: null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Select Client',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: projectNameCtrl,
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
                controller: descriptionCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: timeBudgetCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Budget',
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
                  onPressed: _isBtnEnabled
                      ? () {
                          setState(() {
                            _futureProject = projService.createProject({
                              "project_code": projectCodeCtrl.text,
                              "project_name": descriptionCtrl.text,
                              "description": descriptionCtrl.text,
                              "budget": timeBudgetCtrl.text,
                              "is_active": 1,
                              "product_code": selectedProductValue,
                            });
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileHomeWidget()),
                          );
                        }
                      : null,
                  child: const Text('Save', style: TextStyle(fontSize: 20)),
                )),
          ])),
    );
  }
}

// Detail and Edit project functionality
class DetailProjectWidget extends StatefulWidget {
  // In the constructor require a Product
  const DetailProjectWidget({super.key, required this.project});

  // Declare a field that holds the product
  final dynamic project;

  @override
  State<DetailProjectWidget> createState() => _DetailProjectWidgetState();
}

class _DetailProjectWidgetState extends State<DetailProjectWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditModeEnabled = false;
  Future<dynamic>? _updatedProduct;
  ProjectService projService = ProjectService();

  TextEditingController projectCodeCtrl = TextEditingController();
  TextEditingController projectNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController timeBudgetCtrl = TextEditingController();
  TextEditingController productCodeCtrl = TextEditingController();
  //TextEditingController clientInfoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    projectCodeCtrl.text = widget.project["project_code"].toString();
    projectNameCtrl.text = widget.project["project_name"].toString();
    descriptionCtrl.text = widget.project["description"].toString();
    timeBudgetCtrl.text = widget.project["budget"].toString();
    productCodeCtrl.text = widget.project["product_code"].toString();
    //var clientId = widget.project["description"].toString();

    //start listening to changes
    projectNameCtrl.addListener(() {
      setState(() {
        if (projectNameCtrl.text != widget.project["project_name"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    descriptionCtrl.addListener(() {
      setState(() {
        if (descriptionCtrl.text != widget.project["description"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    timeBudgetCtrl.addListener(() {
      setState(() {
        if (timeBudgetCtrl.text != widget.project["budget"].toString()) {
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
    projectCodeCtrl.dispose();
    projectNameCtrl.dispose();
    descriptionCtrl.dispose();
    timeBudgetCtrl.dispose();
    productCodeCtrl.dispose();
    //clientInfoCtrl.dispose();
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
            title: Text(widget.project["project_code"]),
          ),
          body: Form(
            child: ListView(
              //  ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: productCodeCtrl,
                    decoration: const InputDecoration(
                      //border: OutlineInputBorder(),
                      labelText: 'Product Code *',
                    ),
                    style: const TextStyle(fontSize: 16),
                    enabled: false,
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   child: TextFormField(
                //     controller: productCodeCtrl,
                //     decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Product Code *',
                //     ),
                //     style: const TextStyle(fontSize: 16),
                //     enabled: false,
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: projectCodeCtrl,
                    decoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'Product Code *',
                    ),
                    style: const TextStyle(fontSize: 16),
                    enabled: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: projectNameCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Project Name',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.project["project_name"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: descriptionCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.project["description"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: timeBudgetCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Project Budget',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.project["budget"]) {
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
                                _updatedProduct = projService.updateProject({
                                  "project_name": projectNameCtrl.text,
                                  "description": descriptionCtrl.text,
                                  "budget": timeBudgetCtrl.text,
                                  "id": widget.project["id"],
                                });
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageProjectWidget()),
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
