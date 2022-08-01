import 'package:flutter/material.dart';
import 'app_drawer.dart';

class GenerateReportsWidget extends StatelessWidget {
  const GenerateReportsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: const Center(
        child: Text(
          'Generate Reports',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}