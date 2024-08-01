import 'package:flutter/material.dart';
import 'get_order_status.dart'; // Ensure this import is correct

class SuggestionsChat extends StatefulWidget {
  const SuggestionsChat({super.key, required this.onSendMessage});

  final void Function(String message, {bool isUserMessage, bool isBotResponse}) onSendMessage;

  @override
  State<SuggestionsChat> createState() => _SuggestionsChatState();
}

class _SuggestionsChatState extends State<SuggestionsChat> {
  bool _suggestionsVisible = true;
  bool _waitingForOrderId = false;
  String? _hoveredSuggestion;

  final List<String> _suggestions = [
    'Track my food order',
    'Get help with my order',
    'Technical help',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_suggestionsVisible) // Display suggestions if they are visible
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: _suggestions.map((suggestion) {
                final isHovered = _hoveredSuggestion == suggestion;

                return MouseRegion(
                  onEnter: (_) => setState(() {
                    _hoveredSuggestion = suggestion;
                  }),
                  onExit: (_) => setState(() {
                    _hoveredSuggestion = null;
                  }),
                  child: InkWell(
                    onTap: () => _handleSuggestion(suggestion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isHovered ? Colors.blue[200] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.blue[300]!),
                      ),
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        if (_waitingForOrderId) // No direct dialog here, we'll trigger it on demand
          Container(), // Placeholder, dialog is shown conditionally
      ],
    );
  }

  Future<void> _showOrderIdDialog(BuildContext context) async {
    final TextEditingController _orderIdController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          title: Text(
            'Enter Order ID',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please enter your order ID below:',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _orderIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded text field
                    ),
                    hintText: 'Enter Order ID',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  onSubmitted: (value) => _handleOrderIdSubmission(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleOrderIdSubmission(_orderIdController.text);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue[700], // Text color
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSuggestion(String suggestion) async {
    widget.onSendMessage(
      suggestion,
      isUserMessage: true,
      isBotResponse: false,
    );

    if (suggestion == 'Track my food order') {
      setState(() {
        _suggestionsVisible = false; // Hide suggestions
        _waitingForOrderId = true; // Show order ID input
      });
      // Show the order ID dialog
      await _showOrderIdDialog(context);
    } else if (suggestion == 'Technical help') {
      await Future.delayed(const Duration(seconds: 10)); // Wait for 10 seconds

      String response = 'Please describe the technical issue you are facing.';
      widget.onSendMessage(
        response,
        isUserMessage: false,
        isBotResponse: true,
      );
    } else if (suggestion == 'Who is my order?') {
      await Future.delayed(const Duration(seconds: 10)); // Wait for 10 seconds

      String response = 'Please provide your order ID.';
      widget.onSendMessage(
        response,
        isUserMessage: false,
        isBotResponse: true,
      );
    } else if (suggestion == 'Other') {
      await Future.delayed(const Duration(seconds: 10)); // Wait for 10 seconds

      String response = 'Please describe the issue you are facing.';
      widget.onSendMessage(
        response,
        isUserMessage: false,
        isBotResponse: true,
      );
    } else {
      await Future.delayed(const Duration(seconds: 10));
      String response = 'error'; // Send the suggestion itself
      widget.onSendMessage(
        response,
        isUserMessage: false,
        isBotResponse: true,
      );
    }
  }

  Future<void> _handleOrderIdSubmission(String orderId) async {
    setState(() {
      _waitingForOrderId = false; // Hide order ID input
    });

    if (orderId.isNotEmpty) {
      // Call the getOrderStatus function
      String status = await getOrderStatus(orderId);
      
      // Format the status message with Markdown
      String formattedStatus;
      switch (status) {
        case 'Pending':
          formattedStatus = '*Pending*'; // Italic
          break;
        case 'Preparing':
          formattedStatus = '**Preparing**'; // Bold
          break;
        case 'Confirmed':
          formattedStatus = '`Confirmed`'; // Code style
          break;
        default:
          formattedStatus = '`Other`'; // Inline code with background color
          break;
      }
      
      // Add a delay before sending the message
      await Future.delayed(const Duration(seconds: 2)); // 2-second delay
      
      widget.onSendMessage(
        'Your order is currently: $formattedStatus',
        isUserMessage: false,
        isBotResponse: true,
      );
    } else {
      widget.onSendMessage(
        'Please enter a valid order ID.',
        isUserMessage: false,
        isBotResponse: true,
      );
    }
  }
}
