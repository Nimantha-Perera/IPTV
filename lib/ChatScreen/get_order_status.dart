import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getOrderStatus(String orderId) async {
  try {
    final firestore = FirebaseFirestore.instance;
    // Query the 'orders' collection to find a document where 'order_id' matches the given orderId
    final querySnapshot = await firestore.collection('orders')
        .where('order_id', isEqualTo: orderId)
        .limit(1) // Limit to one document if order_id is unique
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return data['status'] ?? 'Status not found';
    } else {
      return 'Order ID not found';
    }
  } catch (e) {
    return 'Error fetching order status';
  }
}
