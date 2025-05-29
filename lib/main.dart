import 'package:flutter/material.dart';
// import 'package:timetable_projct/Screens/ClassList.dart';
import 'package:timetable_projct/Screens/bottomTab.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.blue,
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.amber,
      // ),
      // themeMode: ThemeMode.system,
    );
  }
}
