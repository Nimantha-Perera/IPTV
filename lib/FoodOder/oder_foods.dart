import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/food_card.dart';
import 'package:iptv_app/FoodOder/food_item.dart';

class OrderFoodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Order Foods',style: TextStyle(color: Colors.black),),
      //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // ),
      body: Padding(
        
        padding: const EdgeInsets.only(left: 10.0, right: 10.0,top: 100.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Adjust the number of columns as needed
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2.0, // Adjust the aspect ratio to make the cards smaller
          ),
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            return FoodCard(food: foodItems[index]);
          },
        ),
      ),
    );
  }
}