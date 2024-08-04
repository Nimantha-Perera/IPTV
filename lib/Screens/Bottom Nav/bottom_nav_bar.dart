import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int messageCount; // Add this line to accept message count

  const BottomNavBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.messageCount = 0, // Default value for message count
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
        items: items.asMap().entries.map((entry) {
          int idx = entry.key;
          BottomNavigationBarItem item = entry.value;
          if (idx == 3) { // Assuming the message icon is at index 3
            return BottomNavigationBarItem(
              icon: Stack(
                children: [
                  item.icon,
                  if (messageCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 15,
                          maxHeight: 15,
                        ),
                        child: Center(
                          child: Text(
                            '$messageCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: item.label,
            );
          } else {
            return item;
          }
        }).toList(),
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
