import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/food_card.dart';
import 'package:iptv_app/FoodOder/food_item.dart';

class OrderFoodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Order Foods', style: TextStyle(color: Colors.black)),
      //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 100.0),
        child: FutureBuilder<List<FoodItem>>(
          future: getFoodItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')
              );
              
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No food items available.'));
            } else {
              final foodItems = snapshot.data!;
              return GridView.builder(
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
              );
            }
          },
        ),
      ),
    );
  }
}
