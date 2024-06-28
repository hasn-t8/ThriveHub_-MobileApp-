import 'package:flutter/material.dart';
import 'screens/Welcome_screens/slider_screen.dart';
import 'screens/Welcome_screens/launcher_screen.dart';
import 'screens/Welcome_screens/welcome_1.dart';
import 'screens/Welcome_screens/welcome_2.dart';
import 'screens/auth_screens/signup_screen.dart';
import 'package:thrive_hub/screens/profile_screens/my_companies_screen.dart'; // Import your my companies screen
import 'package:thrive_hub/screens/profile_screens/account_settings_screen.dart'; // Import your account settings screen
import 'package:thrive_hub/screens/profile_screens/help_center_screen.dart'; // Import your help center screen

void main() {
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
        '/': (context) => SliderScreen(),  // Set SliderScreen as the initial route
        '/launcher': (context) => LauncherScreen(),
        '/welcome1': (context) => Welcome1Screen(),
        '/welcome2': (context) => Welcome2Screen(),
        '/my-companies': (context) => MyCompaniesScreen(),
        '/account-settings': (context) => AccountSettingsScreen(),
        '/help-center': (context) => HelpCenterScreen(),

      },
    );
  }
}
