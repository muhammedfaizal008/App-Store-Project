import 'package:app_store/utils/color_constants.dart';
import 'package:app_store/view/auth_handler/auth_handler.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>AuthHandler()));
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkNavyBlue,
      body: Center(
        child: Icon(
          Icons.storefront, 
          size: 100,        
          color:ColorConstant.lightBlue, 
        ),
      ),
    );
  }
}
