import 'package:flutter/material.dart';
import 'save_chat_history.dart';
import 'suggestions_chat.dart';
import 'get_order_status.dart';
import 'chat_bubble.dart';

class ChatWithHotel extends StatefulWidget {
  const ChatWithHotel({super.key});

  @override
  State<ChatWithHotel> createState() => _ChatWithHotelState();
}

class _ChatWithHotelState extends State<ChatWithHotel> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _sendMessage(String message,
      {bool isUserMessage = true, bool isBotResponse = false}) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': message,
          'isUserMessage': isUserMessage,
          'isBotResponse': isBotResponse
        });
        _controller.clear();
        _saveChatHistory();
      });
    }
  }

  Future<void> _saveChatHistory() async {
    await saveChatHistory(_messages);
  }

  Future<void> _loadChatHistory() async {
    final loadedMessages = await loadChatHistory();
    setState(() {
      _messages.clear();
      _messages.addAll(loadedMessages);
    });
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
      _saveChatHistory();
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Hotel Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewChat,
            tooltip: 'Start New Chat',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message['text'],
                  isUserMessage: message['isUserMessage'],
                  isBotResponse: message['isBotResponse'] ?? false,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SuggestionsChat(
                  onSendMessage: (message,
                      {bool isUserMessage = true, bool isBotResponse = false}) {
                    _sendMessage(message,
                        isUserMessage: isUserMessage,
                        isBotResponse: isBotResponse);
                  },
                ),
                SizedBox(height: 16.0), // Added space between SuggestionsChat and TextField
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)), // Slightly rounded corners
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: TextStyle(fontSize: 18.0), // Larger font size for better readability
                        textInputAction: TextInputAction.send,
                        onSubmitted: (text) => _sendMessage(text),
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between TextField and send button
                    ElevatedButton(
                      onPressed: () => _sendMessage(_controller.text),
                      child: const Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue[700], // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners for button
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Larger hit area
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
