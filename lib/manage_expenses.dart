import 'package:easy_biz_manager/approve_reject_requests.dart';
import 'package:easy_biz_manager/services/expense_service.dart';
import 'package:easy_biz_manager/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_drawer.dart';
import 'package:searchable_listview/searchable_listview.dart';


class ManageExpenseWidget extends StatefulWidget {
  const ManageExpenseWidget({super.key});

  @override
  State<ManageExpenseWidget> createState() => _ManageExpenseWidgetState();
}

class _ManageExpenseWidgetState extends State<ManageExpenseWidget> {
  late Future<List<dynamic>> expList;
  late List<dynamic>? _expList = [];
  late List<dynamic>? _tempExpList = [];
  bool loading = true;
  bool? updatedItem;
  Future<bool>? _response;
  ExpenseService expService = ExpenseService();

  TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getExpData();
  }

  void _getExpData() async {
    _tempExpList = (await expService.getExpenses());
    setState(() {
      loading = false;
      _expList = _tempExpList;
    });
  }

  onItemChanged(String value) {
    setState(() {
      _expList = _tempExpList?.where((element) => element['project_code'].toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     //showSearch(context: context, delegate: MySearchDelegate());
          //   },
          // ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddExpenseWidget()),
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
      ): Column(

          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textCtrl,
                decoration: InputDecoration(
                  hintText: 'Search by Project Code...',
                ),
                onChanged: onItemChanged,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _expList!.length,
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
                        //_response = expService.deleteExpense(_expList![index]);
                        //_expList!.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Text(_expList![index]['project_code'].toString() +
                          "\nAmount " + _expList![index]['amount'].toString()),
                      subtitle: Text("Status: " + _expList![index]['exp_status'].toString()),
                      selectedColor: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailExpenseWidget(expense: _expList![index])
                          ),
                        );
                      },
                      // When a user taps the ListTile, navigate to the DetailScreen.
                      // Notice that you're not only creating a DetailScreen, you're
                      // also passing the current todo through to it.
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              )
            )
          ],
        ),
      drawer: const AppDrawerWidget(),
    );
  }
}

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({Key? key}) : super(key: key);

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  TextEditingController projectCode = TextEditingController();
  TextEditingController expenseDescription = TextEditingController();
  TextEditingController amount = TextEditingController();

  String? selectedProjectValue;
  late List<dynamic>? _projList = [];
  ProjectService projService = ProjectService();
  ExpenseService expService = ExpenseService();
  final _formKey = GlobalKey<FormState>();
  Future<dynamic>? _futureExp;
  bool? isValid = false;

  @override
  void initState() {
    super.initState();
    _getProjList();
  }

  void _getProjList() async {
    var temp = (await projService.getProjects());
    setState(() {
      _projList = temp;
    });
    //selectedProjectValue = _projList![0]["id"].toString();
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
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: DropdownButtonFormField(
                    value: selectedProjectValue,
                    //hint: const Text("Select Product"),
                    style: const TextStyle(
                      color: Colors.black54, //<-- SEE HERE
                      fontSize: 16,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProjectValue = newValue!;
                      });
                    },
                    items: _projList!.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item['project_code'].toString()),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: expenseDescription,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Expense Details',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter expense details';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the amount';
                      }
                      return null;
                    },
                  ),
                ),
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
                      child:
                      const Text('Save', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        _submit();
                        if (isValid == true){
                          setState(() {
                            _futureExp = expService.createExpense({
                              "project_id": selectedProjectValue,
                              "invoice_id": null,
                              "amount": amount.text,
                              "record_date": DateTime.now().toString(),
                              "description": expenseDescription.text,
                              "exp_status": "Requested",
                              "is_active": 1,
                            });
                          });
                          if (_futureExp != null){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ManageExpenseWidget()),
                            );
                          }

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

// Detail and Edit expense functionality
class DetailExpenseWidget extends StatefulWidget {
  // In the constructor require a Product
  const DetailExpenseWidget({super.key, required this.expense});

  // Declare a field that holds the expense
  final dynamic expense;

  @override
  State<DetailExpenseWidget> createState() => _DetailExpenseWidgetState();
}

class _DetailExpenseWidgetState extends State<DetailExpenseWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditModeEnabled = false;
  Future<dynamic>? _updatedExpense;
  ProjectService projService = ProjectService();
  ExpenseService expService = ExpenseService();
  late List<dynamic>? _projList = [];
  String? selectedProjValue;
  bool isLoading = true;

  TextEditingController projCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();

  void _getProjList() async {
    var temp = (await projService.getProjects());
    setState(() {
      _projList = temp;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProjList();

    projCtrl.text = widget.expense["project_code"].toString();
    descriptionCtrl.text = widget.expense["description"].toString();
    amountCtrl.text = widget.expense["amount"].toString();

    //start listening to changes
    projCtrl.addListener(() {
      setState(() {
        if (projCtrl.text != widget.expense["project_id"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    descriptionCtrl.addListener(() {
      setState(() {
        if (descriptionCtrl.text != widget.expense["description"].toString()) {
          _isEditModeEnabled = true;
          return;
        } else {
          _isEditModeEnabled = false;
        }
      });
    });

    amountCtrl.addListener(() {
      setState(() {
        if (amountCtrl.text != widget.expense["amount"].toString()) {
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
    projCtrl.dispose();
    descriptionCtrl.dispose();
    amountCtrl.dispose();
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
            title: Text("Expense"),
          ),
          body: isLoading ? Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),

          ) : Form(
            child: ListView(
              //  ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: projCtrl,
                    decoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'Project Code',
                    ),
                    style: const TextStyle(fontSize: 16),
                    enabled: false,
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
                      if (value != widget.expense["description"]) {
                        _isEditModeEnabled = true;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value != widget.expense["amount"]) {
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
                          _updatedExpense = expService.updateExpense({
                            "amount": amountCtrl.text,
                            "description": descriptionCtrl.text,
                            "record_date": DateTime.now().toString(),
                            "exp_status": "Requested",
                            "id": widget.expense["id"],
                          });
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const ManageExpenseWidget()),
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