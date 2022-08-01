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
              // do something
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