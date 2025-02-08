import 'package:flutter/material.dart';
import 'package:app_store/utils/color_constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  bool _isExploring = false;
  bool _isLoading = true; // Flag to track the loading state

  @override
  void initState() {
    super.initState();
    _loadExploringStatus(); // Load exploring status when the screen initializes
  }

  // 1. Method to load exploring status from SharedPreferences
  Future<void> _loadExploringStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isExploring = prefs.getBool('isExploring') ?? false; // Default to false if not set
    _updateUIState(isExploring); // Update UI based on the fetched status
  }

  // 2. Method to update the UI state
  void _updateUIState(bool isExploring) {
    setState(() {
      _isExploring = isExploring;
      _isLoading = false; // Data has been loaded, stop the loading spinner
    });
  }

  // Set the exploring status in SharedPreferences
  void _setExploringStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isExploring', status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        title: Text(
          "Games",
          style: TextStyle(
            color: ColorConstant.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ColorConstant.lightBlue,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: ColorConstant.lightBlue,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        backgroundColor: ColorConstant.darkNavyBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorConstant.mediumBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: ColorConstant.lightBlue,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: ColorConstant.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, User',
                    style: TextStyle(
                      color: ColorConstant.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      color: ColorConstant.coolGray,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: ColorConstant.white),
              title: Text(
                'Settings',
                style: TextStyle(color: ColorConstant.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: ColorConstant.white),
              title: Text(
                'About Us',
                style: TextStyle(color: ColorConstant.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _isLoading // Show CircularProgressIndicator while loading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorConstant.lightBlue,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isExploring)
                  Container(
                    width: double.infinity,
                    color: ColorConstant.darkNavyBlue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_esports,
                          size: 100,
                          color: ColorConstant.lightBlue,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Explore Games",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Discover and play the latest games now!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorConstant.coolGray,
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isExploring = true;
                            });
                            _setExploringStatus(true); // Save the status as true after pressing the button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "Start Exploring",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isExploring)
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CarouselSlider(
                          items: List.generate(
                            3,
                            (index) => InkWell(
                              onTap: () {
                                // Navigate to IndividualScreen
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "Carousel Item $index",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        // ListView section
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.gamepad, color: ColorConstant.white),
                                title: Text(
                                  'Game ${index + 1}',
                                  style: TextStyle(color: ColorConstant.white),
                                ),
                                onTap: () {
                                  // Navigate to the game details screen
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
