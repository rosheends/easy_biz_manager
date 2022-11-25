import 'package:easy_biz_manager/services/invoice_service.dart';
import 'package:easy_biz_manager/services/project_service.dart';
import 'package:easy_biz_manager/services/user_service.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/mobile/mobile_invoices.dart';
import 'package:easy_biz_manager/views/web/web_invoices.dart';
import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ManageInvoiceWidget extends StatelessWidget {
  const ManageInvoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GenerateInvoiceWidget()),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'The invoices will show up here. Click the button above to create the first invoice.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}

class GenerateInvoiceWidget extends StatefulWidget {
  const GenerateInvoiceWidget({Key? key}) : super(key: key);

  @override
  State<GenerateInvoiceWidget> createState() => _GenerateInvoiceWidgetState();
}

class _GenerateInvoiceWidgetState extends State<GenerateInvoiceWidget> {
  TextEditingController projectCodeCtrl = TextEditingController();
  TextEditingController projectBudgetCtrl = TextEditingController();
  TextEditingController totAmountCtrl = TextEditingController();

  ProjectService projService = ProjectService();
  InvoiceService invService = InvoiceService();
  UserService userService = UserService();
  late List<dynamic>? _projectList = [];
  late dynamic _totalExp;
  late dynamic _totalAmount;
  late dynamic _projId;

  @override
  void initState() {
    super.initState();
    _getProductData();
  }

  void _getProductData() async {
    var temp = (await projService.getProjects());
    setState(() {
      _projectList = temp;
      // selectedProjValue = _projectList[element].
    });
  }

  String? selectedProjValue;
  Future<dynamic>? _futureProject;
  Future<dynamic>? _futureInvoice;
  bool _isBtnEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Invoice'),
      ),
      body: Form(
          child: ListView(
            //  ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                    value: selectedProjValue,
                    //hint: const Text("Select Product"),
                    style: const TextStyle(
                      color: Colors.black54, //<-- SEE HERE
                      fontSize: 16,
                    ),
                    onChanged: (String? newValue) async{
                      _projectList?.forEach((element) async{
                        if (element["id"].toString() == newValue){
                          _projId = element["id"].toString();
                          projectBudgetCtrl.text = Util.printAmount(double.parse(element["budget"].toString()));
                          _totalExp = await invService.getTotalExpense(element["id"].toString());
                          _totalAmount = (_totalExp["totExp"] + double.tryParse(element["budget"])) * 1.15;
                          print(_totalAmount);
                          totAmountCtrl.text = Util.printAmount(_totalAmount);
                        }
                      });
                      setState(() {
                        selectedProjValue = newValue!;
                      });
                    },
                    items: _projectList!.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item['project_code'].toString()),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Select Project',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: projectBudgetCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Project Budget',
                    ),
                    style: const TextStyle(fontSize: 16),
                    enabled: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: totAmountCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total Amount',
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
                      ),
                      onPressed: () {
                        //var temp = userService.getProjClient(_projId);
                        setState(() {
                          _futureInvoice =  invService.createProject({
                            "user_id": 1,//temp[0]["user_id"].toString(),
                            "invoice_date": DateTime.now().toString(),
                            "due_date": DateTime.now().toString(),
                            "late_fee": 0,
                            "total_amount": _totalAmount,
                            "title": "Invoice Report",
                            "payment_status": "Pending",
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Invoice successfully created')));
                        Util.routeNavigatorPush(context, MobileInvoiceWidget(), WebInvoiceWidget());
                      },
                      child: const Text('Generate Invoice', style: TextStyle(fontSize: 15)),
                    )),
              ])),
    );
  }
}