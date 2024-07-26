// lib/_customer_data.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iptv_app/CustomorData/customor_modal.dart';


Future<Customer> fetchCustomerData(String documentId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  try {
    DocumentSnapshot doc = await _firestore.collection('customers').doc(documentId).get();

    if (doc.exists) {
      return Customer.fromFirestore(doc.data() as Map<String, dynamic>);
    } else {
      print('Document does not exist');
      return Customer(
        roomNumber: 'No room number',
        customerName: 'No customer name',
      );
    }
  } catch (e) {
    print('Error fetching data: $e');
    return Customer(
      roomNumber: 'Error',
      customerName: 'Error',
    );
  }
}
