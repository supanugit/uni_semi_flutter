import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Alltimetable extends StatefulWidget {
  const Alltimetable({super.key});

  @override
  State<Alltimetable> createState() => _AlltimetableState();
}

class _AlltimetableState extends State<Alltimetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Timetable")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: InkWell(
            onTap: () async {
              final url = Uri.parse("https://flutter.dev");
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch the URL')),
                );
              }
            },
            child: Text(
              "Go to Mail",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
