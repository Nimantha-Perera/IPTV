import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/food_alert.dart';
import 'package:iptv_app/FoodOder/food_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;

  FoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0),
      splashColor: Colors.blue.withOpacity(0.3), // Change the splash color here
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? roomUserName = prefs.getString('roomUserName');

        // Handle card tap
        print('Selected: ${food.name}');
        showFoodAlertDialog(context, food, roomUserName!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  food.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Adjust the height as needed
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      food.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\Rs ${food.price.toStringAsFixed(2)}/=',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
