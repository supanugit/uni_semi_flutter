import 'package:flutter/material.dart';
import 'package:timetable_projct/Screens/itPage.dart';
import 'package:timetable_projct/Screens/bioPage.dart';

import 'package:timetable_projct/Screens/etPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current_index = 0;
  List<Widget> pages = [ItPage(), EtPage(), BioPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current_index,
        onTap: (value) {
          setState(() {
            current_index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.computer_rounded),
            label: "IT",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_rounded),
            label: "ET",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech_rounded),
            label: "BT",
          ),
        ],
      ),
    );
  }
}
