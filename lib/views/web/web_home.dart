import 'package:easy_biz_manager/approve_reject_requests.dart';
import 'package:easy_biz_manager/manage_expenses.dart';
import 'package:easy_biz_manager/manage_invoices.dart';
import 'package:easy_biz_manager/reporting.dart';
import 'package:easy_biz_manager/views/web/web_invoices.dart';
import 'package:flutter/material.dart';
import '../../manage_projects.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_drawer.dart';
import '../../manage_clients.dart';
import '../../utility/constants.dart';
import '../../utility/util.dart';
import '../common/sign_up.dart';

class WebHomeWidget extends StatelessWidget {
  WebHomeWidget({Key? key}) : super(key: key);

  List<Item> items = [
    // Item(
    //     title: 'Manage Clients',
    //     icon: Icons.people,
    //     screen: const ManageClientWidget()),
    Item(
        title: 'Manage Users',
        icon: Icons.people,
        screen: const UserListWidget()),
    Item(
        title: 'Manage Projects',
        icon: Icons.description_outlined,
        screen: const ManageProjectWidget()),
    Item(
        title: 'Manage Expenses',
        icon: Icons.paid_rounded,
        screen: const ManageExpenseWidget()),
    Item(
        title: 'Manage Invoice',
        icon: Icons.document_scanner_outlined,
        screen: const WebInvoiceWidget()),
    Item(
        title: 'Generate Reports',
        icon: Icons.insert_chart,
        screen: const WebInvoiceWidget()),
  ];

  @override
  Widget build(BuildContext context) {

    if(["1", "3"].contains(Util.loggedUser()["role_id"].toString())){
      items.add(
          Item(
              title: 'Expense Approval',
              icon: Icons.approval,
              screen: const ExpenseRequestsWidget())
      );
    }

    if(["5"].contains(Util.loggedUser()["role_id"].toString())){
      items = [
        Item(
            title: 'Manage Projects',
            icon: Icons.description_outlined,
            screen: const ManageProjectWidget()),
        Item(
            title: 'Manage Expenses',
            icon: Icons.paid_rounded,
            screen: const ManageExpenseWidget()),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),

      ),
      body: GridView.count(
          padding: const EdgeInsets.all(50),
          crossAxisCount: 4,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: items.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<Widget>(builder: (BuildContext context) {
                  return data.screen;
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                    //color: Color(color),
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white
                      ),
                      child: Icon(
                        data.icon,
                        size: 65.0,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
      drawer: const AppDrawerWidget(),
    );
  }
}

class Item {
  final String title;
  final IconData icon;
  final Widget screen;
  Item({required this.title, required this.icon, required this.screen});
}
