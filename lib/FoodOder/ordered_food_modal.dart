import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderedFoodItem {
   final String name;
  final String status;
  final double price;
  final String order_id;


  OrderedFoodItem({required this.name, required this.status, required this.price, required this.order_id});
}

// Future<List<OrderedFoodItem>> getOrderedFoodItems() async {
//   // Simulate a network request or fetch from a database
//   await Future.delayed(Duration(seconds: 2)); // Simulate a delay
//   return [
//     OrderedFoodItem(name: 'Food 1', status: 'Confirmed', price: 12.99),
//     OrderedFoodItem(name: 'Food 2', status: 'Pending', price: 8.49),
//     OrderedFoodItem(name: 'Food 3', status: 'Canceled', price: 15.00),
//   ];
// }

Future<List<OrderedFoodItem>> getOrderedFoodItems() async {
  // Simulate a network request or fetch from a database
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 SharedPreferences prefs = await SharedPreferences.getInstance();
  String? roomUserName = prefs.getString('roomUserName');

  if (roomUserName == null) {
    print('Room username not found in SharedPreferences');
    return [];
  }

  await Future.delayed(Duration(seconds: 2)); // Simulate a delay
  final snapshot = await _firestore.collection('customers').doc(roomUserName).collection('ordered_foods').get();
  return snapshot.docs.map((doc) {
    return OrderedFoodItem(
      name: doc['food_name'],
      status: doc['status'],
      order_id: doc['order_id'],
      price: doc['totalPrice'].toDouble(),
    );
  }).toList();
}


