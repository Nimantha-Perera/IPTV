import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedRoomUserName = prefs.getString('roomUserName');

    if (savedRoomUserName != null && savedRoomUserName.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home', arguments: savedRoomUserName);
    }
  }

  get roomUserName => _roomNumberController.text;

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;

        // Authenticate anonymously
        UserCredential userCredential = await _auth.signInAnonymously();
        User? user = userCredential.user;

        if (user != null) {
          // Fetch customer data based on room number as document ID
          DocumentSnapshot doc = await _firestore
              .collection('customers')
              .doc(user.uid) // Use uid as document ID
              .get();

          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            final customerName = data['customerName'];

            // Save room number to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('roomUserName', roomUserName);

            // Show modal with customer details and navigate with room number
            _showCustomerDetails(customerName);
          } else {
            _showErrorDialog('No customer found with this room number');
          }
        }
      } catch (e) {
        print('Error fetching data: $e');
        _showErrorDialog('Error fetching data. Please try again.');
      }
    }
  }

  void _showCustomerDetails(String customerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Successful'),
          content: Text('Welcome, $customerName!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home', arguments: roomUserName);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child: const Text(
                    'Login IPTV Room',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _roomNumberController,
                          decoration: InputDecoration(
                            labelText: 'Customer Room Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.home),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('LOGIN'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
