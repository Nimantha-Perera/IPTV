import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String name;
  final double price;
  final String imagePath;
  final String id;
  final String customerVisibility;

  FoodItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.id,
    required this.customerVisibility,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data) {
    return FoodItem(
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      imagePath: data['imageUrl'] as String,
      id: data['id'] as String,
      customerVisibility: data['customerVisibility'] as String,
    );
  }
}



// final List<FoodItem> foodItems = [
//   FoodItem(name: 'Pizza', price: 1200, imagePath: 'assets/food_images/pizza.png'),
//   FoodItem(name: 'Burger', price: 800, imagePath: 'assets/food_images/berger.png'),
//   // FoodItem(name: 'Pasta', price: 12.99, imagePath: 'assets/images/pasta.jpg'),
//   // FoodItem(name: 'Salad', price: 5.99, imagePath: 'assets/images/salad.jpg'),
//   // FoodItem(name: 'Sushi', price: 14.99, imagePath: 'assets/images/sushi.jpg'),
//   // FoodItem(name: 'Steak', price: 19.99, imagePath: 'assets/images/steak.jpg'),
// ];

Future<List<FoodItem>> getFoodItems() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final snapshot = await _firestore.collection('availble_foods')
                                   .where('customerVisibility', isEqualTo: 'Visible')
                                   .get();
  return snapshot.docs.map((doc) {
    return FoodItem.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}


