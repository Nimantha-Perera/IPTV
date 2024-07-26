import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iptv_app/CustomorData/customor_data.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Timer _timer;
  String formattedDate = '';
  String formattedTime = '';
  String roomNumber = 'Loading...';
  String customerName = 'Loading...';
  String customerSecruty = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the passed arguments
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map<String, dynamic>) {
      setState(() {
        customerSecruty = arguments['roomNumber'] ?? 'No room number';
      });
      _fetchCustomerData();
    } else if (arguments is String) {
      setState(() {
        customerSecruty = arguments;
      });
      _fetchCustomerData();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    DateTime now = DateTime.now();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(now);
      formattedTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  Future<void> _fetchCustomerData() async {
    try {
      final customer = await fetchCustomerData(customerSecruty);

      setState(() {
        roomNumber = customer.roomNumber;
        customerName = customer.customerName;
      });
    } catch (e) {
      print('Error fetching customer data: $e');
      setState(() {
        roomNumber = 'Error';
        customerName = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thermostat, size: 30, color: Color.fromARGB(255, 255, 0, 0)),
                      const SizedBox(width: 5),
                      Text("26 C",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 0, 0, 0))),
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
                              color: const Color.fromARGB(255, 0, 0, 0))),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 30, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(formattedTime, // Display the formatted time
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 0, 0, 0))),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 100,
              color: const Color.fromARGB(255, 90, 90, 90), // Optional: Add a background color to distinguish the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Room Number: $roomNumber",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 50,),
                  Text("Customer Name: $customerName",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
