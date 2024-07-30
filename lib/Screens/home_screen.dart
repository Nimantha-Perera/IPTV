import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/order_foods.dart';
import 'package:iptv_app/Screens/Bottom%20Nav/bottom_nav_bar.dart';
import 'package:iptv_app/Channels/channels_view.dart';
import 'package:iptv_app/Screens/Naigate_Screens/main_menu.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MainMenu(),
    ChannelsView(),
    OrderFoodsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Channels'),
    BottomNavigationBarItem(icon: Icon(Icons.food_bank_sharp), label: 'Foods'),
    BottomNavigationBarItem(icon: Icon(Icons.messenger), label: 'Contact'),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}


