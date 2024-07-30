import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for clipboard functionality
import 'package:iptv_app/FoodOder/ordered_food_modal.dart';

class OrderedFoodCard extends StatelessWidget {
  final OrderedFoodItem food;

  const OrderedFoodCard({
    Key? key,
    required this.food,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return const Color.fromARGB(255, 0, 255, 255);
      case 'confirmed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
        return Colors.orange.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
       return 'Preparing';
      case 'confirmed':
        return 'Confirmed';
      case 'canceled':
        return 'Canceled';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icon(Icons.check_circle, color: Colors.green, size: 24);
      case 'canceled':
        return Icon(Icons.cancel, color: Colors.red, size: 24);
      case 'pending':
        return Icon(Icons.hourglass_empty, color: Colors.orange.shade700, size: 24);
      default:
        return Icon(Icons.help, color: Colors.grey, size: 24);
    }
  }

  void _copyOrderIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: food.order_id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ID copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(food.status);
    final statusText = _getStatusText(food.status);
    final statusIcon = _getStatusIcon(food.status);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          food.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Rs. ${food.price.toStringAsFixed(2)}/=",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(221, 117, 117, 117),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _copyOrderIdToClipboard(context),
              child: Row(
                children: [
                  Text(
                    'ORDER ID: ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    food.order_id,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 132, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.copy, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                statusIcon,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
