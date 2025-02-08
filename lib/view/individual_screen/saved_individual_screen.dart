import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:downloadsfolder/downloadsfolder.dart' as dwd;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_store/utils/color_constants.dart';

class SavedIndividualScreen extends StatefulWidget {
  final Map<String, dynamic> app; // Accept the app object

  const SavedIndividualScreen({super.key, required this.app});

  @override
  State<SavedIndividualScreen> createState() => _SavedIndividualScreenState();
}

class _SavedIndividualScreenState extends State<SavedIndividualScreen> {
  bool _isDownloading = false; // Track download progress

  /// 🔹 Fetch APK URL from SQLite Database
  Future<String?> getApkUrlFromDatabase(String appTitle) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'apps_library.db'); // Your database name

    final Database db = await openDatabase(path);
    
    // Query the database
    List<Map<String, dynamic>> result = await db.query(
      'AppsLibrary',
      columns: ['apk_url'],
      where: 'title = ?',
      whereArgs: [appTitle],
    );

    if (result.isNotEmpty) {
      return result.first['apk_url'] as String?;
    }

    return null;
  }

  /// 🔹 Download and Install APK
  Future<void> downloadAndInstallApk(String url) async {
    try {
      setState(() => _isDownloading = true);
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          print("Storage permission denied.");
           setState(() => _isDownloading = false);
          return;
        }

        // Get directory
        Directory downloadDirectory = await dwd.getDownloadDirectory();
        String filePath = "${downloadDirectory.path}/app.apk";
        log(filePath);

        // Download APK
        Dio dio = Dio();
        await dio.download(url, filePath);

        if (await Permission.requestInstallPackages.request().isGranted) {
          OpenFile.open(filePath);
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    finally {
    setState(() => _isDownloading = false); 
  }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;

    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstant.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Icon(Icons.more_vert, color: ColorConstant.white),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(app['thumbnail']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app['title'],
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app['author'],
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: ColorConstant.lightBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Contains ads · In-app purchases",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: ColorConstant.coolGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Install Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isDownloading
                        ? null
                        : () async {
                            String? apkUrl = await getApkUrlFromDatabase(app['title']);

                            if (apkUrl == null || apkUrl.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("APK URL not found for this app.")),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Install App'),
                                  content: const Text('Are you sure you want to install this app?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        log("Downloading: $apkUrl");
                                        await downloadAndInstallApk(apkUrl);
                                      },
                                      child: const Text('Install'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isDownloading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Install",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About This App Section
            Text(
              "About this app",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorConstant.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              app['description'],
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: ColorConstant.coolGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget for Info Tiles
  Widget infoTile(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorConstant.white,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: ColorConstant.coolGray,
          ),
        ),
      ],
    );
  }
}
