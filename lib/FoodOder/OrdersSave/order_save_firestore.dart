import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:iptv_app/FoodOder/food_item.dart'; // Adjust import according to your project structure

Future<void> saveOrderToFirestore(FoodItem food, int quantity, String customerName) async {
  var uuid = Uuid();
  String orderId = uuid.v4();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? roomUserName = prefs.getString('roomUserName');

  if (roomUserName == null) {
    print('Room username not found in SharedPreferences');
    return;
  }

  // get room number from firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final snapshot = await _firestore.collection('customers').doc(roomUserName).get();
  String roomNumber = snapshot.data()?['roomNumber'] ?? '';




  // Create an instance of Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Define the collections
  CollectionReference orders = firestore.collection('orders');
  CollectionReference order_user = firestore.collection('customers').doc(roomUserName).collection('ordered_foods');

  // Create the order data
  Map<String, dynamic> orderData = {
    'order_id': orderId,
    'id': food.id,
    'food': food.name,
    'customerName': customerName,
    'price': food.price,
    'roomNumber': roomNumber,
    'quantity': quantity,
    'totalPrice': food.price * quantity,
    'imagePath': food.imagePath,
    
    'status': 'Pending',
    'timestamp': FieldValue.serverTimestamp(),
  };

  try {
    // Save to the 'orders' collection
    await orders.add(orderData);

    // Save to the 'order_details' collection (adjust data structure as needed)
    await order_user.add({
      'order_id': orderId,
      'food_id': food.id,
      'food_name': food.name,
      'quantity': quantity,
      'price': food.price,
      'status': 'Pending',
      'totalPrice': food.price * quantity,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('Order saved successfully to both collections');
  } catch (e) {
    print('Error saving order to Firestore: $e');
  }
}
