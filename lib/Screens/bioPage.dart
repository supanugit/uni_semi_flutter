import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timetable_projct/Screens/about.dart';
import 'package:url_launcher/url_launcher.dart';

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
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

    // today = 2;
    today = DateTime.now().weekday;
    appBar = "Today's BT Classes";

    if (DateTime.now().hour >= 16) {
      today = today + 1;
      appBar = "Tomorrow's BT Classes";
    }
    if (today > 5) {
      today = 1;
      appBar = "Monday BT Classes";
    }

    try {
      final res = await dio
          .get("https://uni-semi.vercel.app/api/bt?day=$today")
          .timeout(const Duration(seconds: 10));

      if (res.data == null || res.data["classDetails"] == null) {
        throw Exception("Invalid data format");
      }

      setState(() {
        fdata = res.data["classDetails"];
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage =
            "Network error: Check Your network and reload the Page by hit the refresh Button";
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
    // Set status bar color
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        splashColor: Colors.deepPurple,
        tooltip: "Info",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => About()),
          );
        },
        child: Icon(Icons.info),
      ),
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
        backgroundColor: Colors.orange,
        elevation: 6,
        shadowColor: Colors.green.withOpacity(0.6),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          onPressed: () {},
          tooltip: "All TimeTable",
          icon: Icon(Icons.view_list, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetch,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.orange,
        color: Colors.white,
        onRefresh: fetch,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              isLoading
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Loading your schedule...",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                  : hasError
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
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
                          label: const Text(
                            'Try Again',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
                  )
                  : fdata.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: fdata.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = fdata[index];
                      return _buildClassCard(item, index);
                    },
                  ),
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> item, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.orange.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row with index and subject
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange.shade100,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item["subject"] ?? "Unknown Subject",
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

            // Teacher Row
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item["teacher"] ?? "Unknown Teacher",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Time Row
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${item["day"]} ${item["time"] ?? 'Unknown Time'}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Location Row
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${item["hall"] ?? "Unknown Room"} (${item["floor"].isEmpty ? "Unknown Floor" : "Floor ${item["floor"]}"})",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
