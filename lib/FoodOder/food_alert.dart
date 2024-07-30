// Your current Dart file
import 'package:flutter/material.dart';
import 'package:iptv_app/CustomorData/customor_data.dart';
import 'package:iptv_app/FoodOder/OrdersSave/order_save_firestore.dart';
import 'package:iptv_app/FoodOder/food_item.dart';
import 'package:iptv_app/CustomorData/customor_modal.dart';


void showFoodAlertDialog(BuildContext context, FoodItem food, String customerId) async {
  if (food == null || food.imagePath == null || food.name == null || food.price == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: Food item data is incomplete.')),
    );
    return;
  }

  // Fetch customer data
  Customer customer = await fetchCustomerData(customerId);
  final TextEditingController quantityController = TextEditingController(text: '1');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        title: Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              food.imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            SizedBox(height: 10),
            Text(
              food.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '\Rs ${food.price.toStringAsFixed(2)}/=',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    int currentQuantity = int.parse(quantityController.text);
                    if (currentQuantity > 1) {
                      quantityController.text = (currentQuantity - 1).toString();
                    }
                  },
                ),
                Container(
                  width: 50,
                  child: TextField(
                    controller: quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    int currentQuantity = int.parse(quantityController.text);
                    quantityController.text = (currentQuantity + 1).toString();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Do you want to confirm your order?'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Confirm'),
            onPressed: () async {
              int quantity = int.parse(quantityController.text);
              await saveOrderToFirestore(food, quantity, customer.customerName);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order Confirmed for ${quantity} x ${food.name}'),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
