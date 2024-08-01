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
            if (food.imagePath != null && food.imagePath!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  food.imagePath!,
                  width: double.infinity,
                  height: 100.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 100.0,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 50.0,
                      color: Colors.grey,
                    ),
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