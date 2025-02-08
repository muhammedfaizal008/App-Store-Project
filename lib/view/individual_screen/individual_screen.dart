import 'dart:developer';
import 'dart:io';
import 'package:app_store/controller/database_helper.dart';
import 'package:app_store/controller/individual_app_controller.dart';
import 'package:app_store/utils/color_constants.dart';
import 'package:dio/dio.dart';
import 'package:downloadsfolder/downloadsfolder.dart' as dwd;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class IndividualScreen extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? appData;

  const IndividualScreen({super.key, this.index, this.appData})
      : assert(index != null || appData != null, "Either index or appData must be provided");

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  bool _isAddedToLibrary = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    checkIfAddedToLibrary();
  }

  Future<void> checkIfAddedToLibrary() async {
    List<Map<String, dynamic>> libraryApps = await DatabaseHelper.getAppsFromLibrary();
    final app = widget.appData ?? Provider.of<IndividualAppController>(context, listen: false).apps[widget.index!];

    setState(() {
      _isAddedToLibrary = libraryApps.any((storedApp) => storedApp['title'] == app['title']);
    });
  }

  Future<void> downloadAndInstallApk(String url) async {
    try {
      setState(() => _isDownloading = true);

      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          setState(() => _isDownloading = false);
          return;
        }

        Directory downloadDirectory = await dwd.getDownloadDirectory();
        String filePath = "${downloadDirectory.path}/app.apk";
        log(filePath);

        Dio dio = Dio();
        await dio.download(url, filePath);

        if (await Permission.requestInstallPackages.request().isGranted) {
          OpenFile.open(filePath);
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download or install app: ${e.toString()}")),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<IndividualAppController>(context);

    if (widget.appData == null) {
      if (controller.isLoading) {
        return Scaffold(
          backgroundColor: ColorConstant.darkNavyBlue,
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.apps.isEmpty || widget.index! >= controller.apps.length) {
        return Scaffold(
          backgroundColor: ColorConstant.darkNavyBlue,
          body: Center(
            child: Text(
              "App not found",
              style: GoogleFonts.roboto(color: ColorConstant.white, fontSize: 18),
            ),
          ),
        );
      }
    }

    final app = widget.appData ?? controller.apps[widget.index!];

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_isAddedToLibrary) {
                          await DatabaseHelper.addAppToLibrary(app);
                          setState(() {
                            _isAddedToLibrary = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${app['title']} added to library!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAddedToLibrary ? Colors.grey : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        _isAddedToLibrary ? "Added to library" : "Add to library",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isDownloading
                          ? null
                          : () async {
                              String apkUrl = app['apk_url'];

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Install App'),
                                    content: const Text('Are you sure you want to install this app?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          log("Downloading...");
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
      ),
    );
  }
}
