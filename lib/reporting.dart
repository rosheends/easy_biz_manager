import 'package:easy_biz_manager/views/common/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_drawer.dart';
import 'manage_projects.dart';

class GenerateReportsWidget extends StatelessWidget {
  GenerateReportsWidget({super.key});

  List<Item> items = [
    Item(
        title: 'Expense Summary Report',
        icon: Icons.monetization_on,
        screen: const UserListWidget()),
    Item(
        title: 'Project Summary Report',
        icon: Icons.multiline_chart,
        screen: const ManageProjectWidget()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biz Manager"),
      ),
      body: GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
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
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 3, color: Colors.white)),
                      child: Icon(
                        data.icon,
                        size: 45.0,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
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