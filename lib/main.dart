import 'package:app_store/controller/apps_screen_controller.dart';
import 'package:app_store/controller/database_helper.dart';
import 'package:app_store/controller/individual_app_controller.dart';
import 'package:app_store/controller/login_screen_controller.dart';
import 'package:app_store/controller/search_screen_controller.dart';
import 'package:app_store/controller/signin_screen_controller.dart';
import 'package:app_store/firebase_options.dart';
import 'package:app_store/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper.initialiseDatabase();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginScreenController(),),
        ChangeNotifierProvider(create: (context) => SigninScreenController(),),
        ChangeNotifierProvider(create: (context) => AppsScreenController(),),
        ChangeNotifierProvider(create: (context) => IndividualAppController(),),
        ChangeNotifierProvider(create: (context) => SearchScreenController(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: SplashScreen(),
      ),
    );
  }
}