import 'package:flutter/material.dart';
import 'package:iptv_app/Screens/home_screen.dart';
import 'package:iptv_app/Splash_Screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      theme: ThemeData(

        
      ),
      home: SplashScreen(),
    );
  }
}




