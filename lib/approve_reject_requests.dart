import 'package:easy_biz_manager/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ExpenseRequestsWidget extends StatefulWidget {
  const ExpenseRequestsWidget({super.key});

  @override
  State<ExpenseRequestsWidget> createState() => _ExpenseRequestsWidgetState();
}

class _ExpenseRequestsWidgetState extends State<ExpenseRequestsWidget> {
  late Future<List<dynamic>> expList;
  late List<dynamic>? _expList = [];
  late List<dynamic>? _approvedList = [];
  late List<dynamic>? _rejectedList = [];
  bool loading = true;
  bool? updatedItem;
  Future<bool>? _response;
  ExpenseService expService = ExpenseService();
  Future<dynamic>? _updatedExpense;
  bool status = true;
  TextEditingController _textCtrl = TextEditingController();
  late List<dynamic>? _tempExpList = [];

  @override
  void initState() {
    super.initState();
    _getExpData();
  }

  void _getExpData() async {
    var temp = (await expService.getRequests('Requested'));
    setState(() {
      loading = false;
      _expList = temp;
    });
  }

  void _getApprovedExpData() async {
    var temp = (await expService.getRequests('Approved'));
    setState(() {
      loading = false;
      _expList = temp;
    });
  }

  void _getRejectedData() async {
    var temp = (await expService.getRequests('Rejected'));
    setState(() {
      loading = false;
      _expList = temp;
    });
  }

  onItemChanged(String value) {
    setState(() {
      _expList = _expList?.where((element) => element['project_code'].toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Requested"),

                  ),

                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Approved"),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Rejected"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  _getExpData();
                  status = true;
                }else if(value == 1){
                  _getApprovedExpData();
                  status = false;
                }else if(value == 2){
                  _getRejectedData();
                  status = false;
                }
              }
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

      ): Column(children: <Widget>[
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
              title: Text(_expList![index]['project_code'].toString() + " - " + _expList![index]['description'].toString()+
                  "\nAmount " + _expList![index]['amount'].toString()),
              subtitle: Text("Status: " + _expList![index]['exp_status'].toString()),
              selectedColor: Colors.blueAccent,
              onTap: () {
              },
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'Approve',
                      child: Text('Approve'),
                      enabled: status,
                    ),
                    PopupMenuItem(
                      value: 'Reject',
                      child: Text('Reject'),
                      enabled: status,
                    )
                  ];
                },
                onSelected: (String value){
                  if (value == 'Approve'){
                    print("Approved");
                    _updatedExpense = expService.updateStatus({
                      "exp_status": "Approved",
                      "id": _expList![index]['id'].toString(),
                    });
                    //_getExpData();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ManageExpenseWidget()),
                    // );

                  }else if (value == "Reject"){
                    print("Rejected");
                    _updatedExpense = expService.updateStatus({
                      "exp_status": "Rejected",
                      "id": _expList![index]['id'].toString(),
                    });

                   // _getExpData();
                  }
                  setState(() {
                    _getExpData();
                  });
                },
              ),

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