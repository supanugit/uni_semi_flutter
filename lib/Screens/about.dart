import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri.parse(
      email.startsWith('mailto:') ? email : 'mailto:$email',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      debugPrint("Could not launch email: $emailLaunchUri");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),

            // App Name and Version
            const Text(
              "RUSL 22/23 Timetable",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Version 2.0.1",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            const Divider(thickness: 1),
            const SizedBox(height: 24),

            // Developer Section
            const Text(
              "Developed by",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "T.Supanusan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Contact Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Contact Developer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "For support, feature requests, or bug reports",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.email_rounded,
                          color: Colors.blue,
                          label: "Email",
                          onTap: () => _launchEmail("ssupanusan@gmail.com"),
                        ),
                        _buildActionButton(
                          icon: Icons.bug_report_rounded,
                          color: Colors.red,
                          label: "Report Bug",
                          onTap:
                              () => _launchEmail(
                                "mailto:ssupanusan@gmail.com?subject=Bug Report",
                              ),
                        ),
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          color: Colors.green,
                          label: "Share",
                          onTap: () {
                            // Add share functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Copyright
            const Text(
              "© 2023 T.Supanusan",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Text(
              "All rights reserved",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
