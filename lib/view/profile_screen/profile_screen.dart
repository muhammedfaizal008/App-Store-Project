import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_store/utils/color_constants.dart';
import 'package:app_store/view/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  String _userName = "User Name";
  String _email = "useremail@gmail.com";
  String _profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      setState(() {
        _email = _user!.email ?? "No email found";
      });

      // Fetch additional user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "User Name";
          _profileImageUrl = userDoc['profileImageUrl'] ?? "";
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all shared preferences data
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logged out successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to log out: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: ColorConstant.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: ColorConstant.coolGray,
              backgroundImage:
                  _profileImageUrl.isNotEmpty ? NetworkImage(_profileImageUrl) : null,
              child: _profileImageUrl.isEmpty
                  ? Icon(Icons.person, size: 60, color: ColorConstant.white)
                  : null,
            ),
            SizedBox(height: 16),

            // User Name
            Text(
              _userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 8),

            // Email
            Text(
              _email,
              style: TextStyle(
                fontSize: 16,
                color: ColorConstant.coolGray,
              ),
            ),
            SizedBox(height: 24),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.lightBlue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.white,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Logout",
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
    );
  }
}
