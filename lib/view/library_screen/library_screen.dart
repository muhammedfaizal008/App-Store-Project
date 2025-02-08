import 'package:app_store/controller/database_helper.dart';
import 'package:app_store/view/individual_screen/individual_screen.dart';
import 'package:app_store/view/individual_screen/saved_individual_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_store/utils/color_constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> savedApps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedApps();
  }

  Future<void> fetchSavedApps() async {
    List<Map<String, dynamic>> apps = await DatabaseHelper.getAppsFromLibrary();
    setState(() {
      savedApps = apps;
      isLoading = false;
    });
  }

  Future<void> deleteApp(int id) async {
    await DatabaseHelper.deleteApp(id);
    fetchSavedApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        title: Text(
          "Library",
          style: TextStyle(
            color: ColorConstant.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: ColorConstant.darkNavyBlue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Search TextField
            // TextField(
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: ColorConstant.white,
            //     hintText: 'Search your library...',
            //     hintStyle: TextStyle(color: ColorConstant.coolGray),
            //     prefixIcon: Icon(Icons.search, color: ColorConstant.lightBlue),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //       borderSide: BorderSide.none,
            //     ),
            //   ),
            //   style: TextStyle(color: ColorConstant.white),
            //   onChanged: (value) {
            //     // Add search logic here
            //   },
            // ),
            // SizedBox(height: 30),

            // Show either the list of apps or the placeholder UI
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: ColorConstant.lightBlue))
                  : savedApps.isEmpty
                      ? buildEmptyState()
                      : ListView.builder(
                          itemCount: savedApps.length,
                          itemBuilder: (context, index) {
                            var app = savedApps[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900], // Set your desired background color
                                  borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(app['thumbnail']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    app['title'],
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    app['author'],
                                    style: TextStyle(color: ColorConstant.coolGray, fontSize: 14),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteApp(app['id']),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SavedIndividualScreen(app: app),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );

                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder UI when no apps are saved
  Widget buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.library_books, size: 100, color: ColorConstant.lightBlue),
        SizedBox(height: 20),
        Text(
          "Your Saved and Purchased Games",
          style: TextStyle(
            color: ColorConstant.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "This is where your purchased or installed games will appear.",
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorConstant.coolGray, fontSize: 16),
        ),
      ],
    );
  }
}
