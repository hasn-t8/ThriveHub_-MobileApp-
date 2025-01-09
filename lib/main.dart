// imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_slider_screen.dart';
import 'package:thrive_hub/screens/business/widgets/business_bottom_navigation_bar.dart';
import 'package:thrive_hub/widgets/bottom_navigation_bar.dart';
import 'screens/welcome_screens/main_screen.dart';
import 'screens/welcome_screens/first_screen.dart';
import 'screens/welcome_screens/splash_screen.dart';
import 'screens/welcome_screens/welcome_one.dart';
import 'screens/welcome_screens/welcome_two.dart';
import 'screens/user/auth/sign_up.dart';
import 'screens/user/profile_screens/my_companies_screen.dart';
import 'screens/user/profile_screens/account_settings_screen.dart';
import 'screens/user/profile_screens/help_center_screen.dart';
import 'package:thrive_hub/screens/user/auth/sign_in.dart'; // Assuming you have a login screen
import 'package:thrive_hub/screens/business/notification_screens/business_notification_screen.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_help_center.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_edit_account.dart';
import 'package:thrive_hub/screens/business/auth/sign_up.dart';
import 'package:thrive_hub/screens/business/auth/sign_in.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Status bar color
    statusBarIconBrightness: Brightness.dark, // For Android: dark icons
    statusBarBrightness: Brightness.light, // For iOS: dark icons
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Thrive Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // user screen routes
        '/': (context) =>
            SplashScreen(), // Set SliderScreen as the initial route
        '/welcome': (context) =>
            SliderScreen(), // Set SliderScreen as the initial route
        '/dashboard': (context) => MainScreen(),
        '/launcher': (context) => LauncherScreen(),
        '/welcome1': (context) => Welcome1Screen(),
        '/welcome2': (context) => Welcome2Screen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => SignInScreen(), // Define your login screen
        '/my-companies': (context) => MyCompaniesScreen(),
        '/account-settings': (context) => AccountSettingsScreen(),
        '/help-center': (context) => HelpCenterScreen(),
        //business screens
        '/business-sign-up': (context) => BusinessSignUpScreen(),
        '/business-sign-in': (context) => BusinessSignInScreen(),
        '/business-notification': (context) => BusinessNotificationScreen(),
        '/business-help-center': (context) => BusinessHelpCenterScreen(),
        '/business-account-settings': (context) => BusinessAccountScreen(),
        '/business-profile-setup': (context) => BusinessSliderScreen(),
        '/business-home': (context) => BusinessMainScreen(),
      },
    );
  }
}
