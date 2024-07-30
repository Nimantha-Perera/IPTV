import 'package:flutter/material.dart';
import 'package:iptv_app/FoodOder/ordered_food_modal.dart';
import 'package:iptv_app/FoodOder/ordered_foods_card.dart';
import 'food_card.dart';
import 'food_item.dart';

class OrderFoodsScreen extends StatefulWidget {
  @override
  _OrderFoodsScreenState createState() => _OrderFoodsScreenState();
}

class _OrderFoodsScreenState extends State<OrderFoodsScreen> {
  late Future<List<FoodItem>> _foodItemsFuture;
  late Future<List<OrderedFoodItem>> _orderedFoodItemsFuture;

  @override
  void initState() {
    super.initState();
    _foodItemsFuture = getFoodItems();
    _orderedFoodItemsFuture = getOrderedFoodItems();
  }

  void _refreshData() {
    setState(() {
      _foodItemsFuture = getFoodItems();
      _orderedFoodItemsFuture = getOrderedFoodItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Order Foods', style: TextStyle(color: Colors.black)),
          actions: [
            Row(
              children: [
                Text('Refresh List', style: TextStyle(color: Colors.black)),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black),
                  onPressed: _refreshData,
                ),
              ],
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Order Food'),
              Tab(text: 'Ordered Food'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: FutureBuilder<List<FoodItem>>(
                future: _foodItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No food items available.'));
                  } else {
                    final foodItems = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 2.0,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<OrderedFoodItem>>(
                future: _orderedFoodItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No ordered food items available.'));
                  } else {
                    final orderedFoodItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: orderedFoodItems.length,
                      itemBuilder: (context, index) {
                        return OrderedFoodCard(food: orderedFoodItems[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
