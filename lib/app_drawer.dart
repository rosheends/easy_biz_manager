import 'package:easy_biz_manager/manage_products.dart';
import 'package:easy_biz_manager/manage_projects.dart';
import 'package:easy_biz_manager/reporting.dart';
import 'package:flutter/material.dart';
import 'manage_projects.dart';
import 'manage_clients.dart';
import 'manage_expenses.dart';
import 'manage_invoices.dart';
import 'reporting.dart';
import 'manage_products.dart';
import 'home_page.dart';

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
                child: Text(''),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              iconColor: Colors.blue,
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.ballot_rounded),
              iconColor: Colors.blue,
              title: const Text('Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProductsWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              iconColor: Colors.blue,
              title: const Text('Projects'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProjectWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              iconColor: Colors.blue,
              title: const Text('Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageClientWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              iconColor: Colors.blue,
              title: const Text('Vendors'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.paid_rounded),
              iconColor: Colors.blue,
              title: const Text('Expenses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageExpenseWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              iconColor: Colors.blue,
              title: const Text('Invoices'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageInvoiceWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              iconColor: Colors.blue,
              title: const Text('Reports'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenerateReportsWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              iconColor: Colors.blue,
              title: const Text('Help'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.blue,
              title: const Text('Sign Out'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      );
  }
}
