import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:vpn_test_app/main_screen.dart';
import 'package:vpn_test_app/utils.dart';

void main() {
  runApp(const VpnApp());
}

class VpnApp extends StatelessWidget {
  const VpnApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/splash.png'),
        splashIconSize: 350.0,
        nextScreen: const MainScreen(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: bgColor,
        duration: 500,
      ),
    );
  }
}

