// imports
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thrive_hub/screens/business/widgets/business_bottom_navigation_bar.dart';
import 'package:thrive_hub/screens/user/search_screens/sub_categories_screen.dart';
import 'screens/user/welcome_screens/slider_screen.dart';
import 'screens/user/welcome_screens/launcher_screen.dart';
import 'screens/user/welcome_screens/welcome_one.dart';
import 'screens/user/welcome_screens/welcome_two.dart';
import 'screens/user/auth_screens/signup_screen.dart';
import 'screens/user/profile_screens/my_companies_screen.dart';
import 'screens/user/profile_screens/account_settings_screen.dart';
import 'screens/user/profile_screens/help_center_screen.dart';
import 'package:thrive_hub/screens/user/auth_screens/signin_screen.dart'; // Assuming you have a login screen
import 'package:thrive_hub/screens/business/notification_screens/business_notification_screen.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_help_center.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_edit_account.dart';



Future<void> main() async {
  // Load the .env file
  await dotenv.load(fileName: ".env");
// Debug prints
  print('Current directory: ${Directory.current.path}');
  print('Does .env file exist? ${File('.env').existsSync()}');
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      title: 'Thrive Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // user screen routes
        '/': (context) => SliderScreen(),  // Set SliderScreen as the initial route
        '/launcher': (context) => LauncherScreen(),
        '/welcome1': (context) => Welcome1Screen(),
        '/welcome2': (context) => Welcome2Screen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => SignInScreen(), // Define your login screen
        '/my-companies': (context) => MyCompaniesScreen(),
        '/account-settings': (context) => AccountSettingsScreen(),
        '/help-center': (context) => HelpCenterScreen(),
        '/home': (context) => MainScreen(),
        '/subcategory': (context) => SubcategoriesScreen(categoryTitle: '',),


        //business screens
        '/business-notification':(context)=> BusinessNotificationScreen(),
        '/business-help-center':(context) => BusinessHelpCenterScreen(),
        '/business-account-settings' : (context) => BusinessAccountScreen(),
      },
    );
  }
}


