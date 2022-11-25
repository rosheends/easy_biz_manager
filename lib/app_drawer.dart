import 'package:easy_biz_manager/approve_reject_requests.dart';
import 'package:easy_biz_manager/manage_invoices.dart';
import 'package:easy_biz_manager/manage_products.dart';
import 'package:easy_biz_manager/manage_projects.dart';
import 'package:easy_biz_manager/reporting.dart';
import 'package:easy_biz_manager/utility/constants.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/common/sign_up.dart';
import 'package:easy_biz_manager/views/mobile/mobile_invoices.dart';
import 'package:easy_biz_manager/views/web/web_home.dart';
import 'package:easy_biz_manager/views/web/web_invoices.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'manage_projects.dart';
import 'manage_expenses.dart';
import 'reporting.dart';
import 'manage_products.dart';
import 'views/mobile/mobile_home.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(Constants.appName, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Home'),
              onTap: () {
                Util.routeNavigatorPush(context, MobileHomeWidget(), WebHomeWidget());
              },
            ),
            ListTile(
              leading: const Icon(Icons.ballot_rounded),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Products'),
              onTap: () {
                Util.routeNavigatorPush(context, ManageProductsWidget(), ManageProductsWidget());
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.people),
            //   iconColor: Colors.blue,
            //   horizontalTitleGap: 0,
            //   title: const Text('Clients'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ManageClientWidget()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.people),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserListWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Projects'),
              onTap: () {
                Util.routeNavigatorPush(context, ManageProjectWidget(), ManageProjectWidget());
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.people_outline),
            //   iconColor: Colors.blue,
            //   horizontalTitleGap: 0,
            //   title: const Text('Vendors'),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.paid_rounded),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Expenses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageExpenseWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.paid_rounded),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Expense Approval'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExpenseRequestsWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Invoices'),
              onTap: () {
                Util.routeNavigatorPush(context, MobileInvoiceWidget(), WebInvoiceWidget());
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Reports'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenerateInvoiceWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Help'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.blue,
              horizontalTitleGap: 0,
              title: const Text('Sign Out'),
              onTap: () {
                final LocalStorage storage = LocalStorage('biz_app');
                storage.deleteItem("auth_key");
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      );
  }
}
