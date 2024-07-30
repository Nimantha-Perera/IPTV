import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iptv_app/Login/login_user.dart';
import 'package:iptv_app/Screens/home_screen.dart';
import 'package:iptv_app/Splash_Screen/splash_screen.dart';
import 'package:iptv_app/firebase_options.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
      theme: ThemeData(),

      home: LoginUser(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginUser(),
      },
    );
  }
}
