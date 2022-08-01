import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ManageExpenseWidget extends StatelessWidget {
  const ManageExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
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
          'Your expenses will show up here. Click the button above to create/approve/reject expenses.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}