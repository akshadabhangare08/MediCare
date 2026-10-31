
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
// import 'widgets/bottom_nav_bar.dart';
// import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
void main() {
  runApp(MediCareApp());
}

class MediCareApp extends StatelessWidget {
  MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCare',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
