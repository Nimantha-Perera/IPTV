import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 120, 185, 238),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thermostat, size: 30, color: Colors.white),
                      const SizedBox(width: 5),
                      Text("26 C",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, size: 30, color: Colors.yellow),
                      const SizedBox(width: 5),
                      Text("Sunny",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 30, color: Colors.white),
                      const SizedBox(width: 5),
                      Text("10:00 AM",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome to IPTV",
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.normal)),
                  const SizedBox(width: 50),
                  Icon(Icons.tv, size: 50),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
