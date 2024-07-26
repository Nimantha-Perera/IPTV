// lib/models/customer.dart

class Customer {
  final String roomNumber;
  final String customerName;

  Customer({
    required this.roomNumber,
    required this.customerName,
  });

  // Factory constructor to create a Customer instance from a Firestore document
  factory Customer.fromFirestore(Map<String, dynamic> data) {
    return Customer(
      roomNumber: data['roomNumber'] ?? 'No room number',
      customerName: data['customerName'] ?? 'No customer name',
    );
  }

  // Method to convert the Customer instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'customerName': customerName,
    };
  }
}
