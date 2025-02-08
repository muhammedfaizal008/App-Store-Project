import 'package:app_store/utils/color_constants.dart';
import 'package:app_store/view/apps_screen/apps_screen.dart';
import 'package:app_store/view/games_screen/games_screen.dart';
import 'package:app_store/view/library_screen/library_screen.dart';
import 'package:app_store/view/profile_screen/profile_screen.dart';
import 'package:app_store/view/search_screen/search_screen.dart';
import 'package:flutter/material.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    AppsScreen(),
    GamesScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,  // Set scaffold background to match the navbar color
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 74, 106, 200),
          borderRadius: BorderRadius.circular(20), // Full border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),  // Slight dark shadow for elevation
              offset: Offset(0, -3), // Shadow at the top of the bar (elevation)
              blurRadius: 8, 
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 65,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent, // Use parent's color
                unselectedItemColor: ColorConstant.coolGray,
                selectedItemColor: ColorConstant.lightBlue,
                showSelectedLabels: true,
                selectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                showUnselectedLabels: false,
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    activeIcon: BottomNavbarTranstion(
                      icon: Icon(Icons.apps, color: ColorConstant.white, size: 22),
                    ),
                    icon: Icon(Icons.apps_outlined, size: 22),
                    label: "Apps",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: BottomNavbarTranstion(
                      icon: Icon(Icons.sports_esports, color: ColorConstant.white),
                    ),
                    icon: Icon(Icons.sports_esports_outlined),
                    label: "Games",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: BottomNavbarTranstion(
                      icon: Icon(Icons.search, color: ColorConstant.white),
                    ),
                    icon: Icon(Icons.search_outlined),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: BottomNavbarTranstion(
                      icon: Icon(Icons.library_books, color: ColorConstant.white),
                    ),
                    icon: Icon(Icons.library_books_outlined),
                    label: "Library",
                  ),
                  BottomNavigationBarItem(
                    activeIcon: BottomNavbarTranstion(
                      icon: Icon(Icons.person_outline, color: ColorConstant.white),
                    ),
                    icon: Icon(Icons.person_outline),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavbarTranstion extends StatelessWidget {
  final Widget icon;

  const BottomNavbarTranstion({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            ColorConstant.mediumBlue,
            ColorConstant.lightBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: icon),
    );
  }
}
