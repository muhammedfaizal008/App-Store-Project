import 'package:app_store/controller/apps_screen_controller.dart';
import 'package:app_store/utils/color_constants.dart';
import 'package:app_store/view/individual_screen/individual_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  bool _hasExplored = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExplorationStatus();
  }

  void _loadExplorationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasExplored = prefs.getBool('hasExplored') ?? false;
      _isLoading = false;
    });
  }

  void _setExplorationStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasExplored', status);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppsScreenController>(context);

    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        title: Text(
          "Apps",
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
      body: controller.isLoading || _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorConstant.lightBlue,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_hasExplored)
                  _buildExploreSection(),
                if (_hasExplored)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          _buildCarousel(),
                          SizedBox(height: 20),
                          _buildAppList(controller),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildExploreSection() {
    return Container(
      width: double.infinity,
      color: ColorConstant.darkNavyBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.apps,
            size: 100,
            color: ColorConstant.lightBlue,
          ),
          SizedBox(height: 20),
          Text(
            "Explore Apps",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorConstant.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Discover and install the latest apps now!",
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
                _hasExplored = true;
              });
              _setExplorationStatus(true);
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
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: List.generate(
        3,
        (index) => InkWell(
          onTap: () {
            
          },
          child: Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
    );
  }

  Widget _buildAppList(AppsScreenController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Popular Apps",
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: controller.apps.length,
              itemBuilder: (context, index) {
                var app = controller.apps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualScreen(index: index),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              app["thumbnail"]!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app["title"],
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  app["author"],
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
