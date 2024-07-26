import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.blue,
        ),
      ),
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: const Color.fromARGB(255, 65, 65, 65), // Set background color
        type: BottomNavigationBarType.fixed, // To ensure the background color covers the whole bar
        elevation: 10, // Add elevation for a shadow effect
        selectedFontSize: 14, // Adjust font size of selected item
        unselectedFontSize: 6, // Adjust font size of unselected items
      ),
    );
  }
}
