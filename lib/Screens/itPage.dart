import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItPage extends StatefulWidget {
  const ItPage({super.key});

  @override
  State<ItPage> createState() => _ItPageState();
}

class _ItPageState extends State<ItPage> {
  final dio = Dio();
  int today = 1;
  List<dynamic> fdata = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String appBar = "";

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    today = DateTime.now().weekday % 7;
    appBar = "Today's IT Classes";

    if (DateTime.now().hour >= 17) {
      today += 1;
      appBar = "Tomorrow's IT Classes";
    }
    if (today > 5) {
      today = 1;
      appBar = "Monday IT Classes";
    }

    try {
      final res = await dio
          .get("https://uni-semi.vercel.app/api/it?day=$today")
          .timeout(const Duration(seconds: 10));

      if (res.data == null || res.data["classDetails"] == null) {
        throw Exception("Invalid data format");
      }

      setState(() {
        fdata = res.data["classDetails"];
        isLoading = false;
      });
    } on DioException {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Network error: Check your connection and try again.";
      });
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Error: ${e.toString()}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.blue[700],
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          appBar,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 6,
        shadowColor: Colors.blue.withOpacity(0.6),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          onPressed: () {},
          tooltip: "All TimeTable",
          icon: const Icon(Icons.view_list, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetch,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3, color: Colors.blue[700]),
            const SizedBox(height: 20),
            const Text(
              "Loading your schedule...",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: fetch,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (fdata.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text(
              "No Class Found!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enjoy your free time.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: fdata.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = fdata[index];
        return _buildClassCard(item, index);
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> item, int index) {
    final subject = item['subject']?.toString() ?? 'No Subject';
    final teacher = item['teacher']?.toString() ?? 'Unknown';
    final time = item['time']?.toString() ?? 'Not specified';
    final classroom = item['hall']?.toString() ?? 'Room not set';
    final floor = item['floor']?.toString() ?? '?';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.blue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.person, teacher),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time, time),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.location_on, '$classroom (Floor $floor)'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
      ],
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }
}
