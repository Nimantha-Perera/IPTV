import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/food_item.dart';

void showFoodAlertDialog(BuildContext context, FoodItem food) {
  if (food == null || food.imagePath == null || food.name == null || food.price == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: Food item data is incomplete.'),
    ));
    return;
  }

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
            Image.asset(
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
              '\$${food.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, color: Colors.green),
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
            onPressed: () {
              // Handle order confirmation
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Order Confirmed for ${food.name}'),
              ));
            },
          ),
        ],
      );
    },
  );
}
