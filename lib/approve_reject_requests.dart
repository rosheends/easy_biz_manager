import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ExpenseRequestsWidget extends StatelessWidget {
  const ExpenseRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Requests'),
      ),
      body: const Center(
        child: Text(
          'Approval Pending Expense Requests',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}