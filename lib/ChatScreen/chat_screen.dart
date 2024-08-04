import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _chatId;

  @override
  void initState() {
    super.initState();
    _authenticateAndStartChat();
  }

  Future<void> _authenticateAndStartChat() async {
    // Check if a user is already signed in
    if (FirebaseAuth.instance.currentUser == null) {
      // Sign in anonymously
      await FirebaseAuth.instance.signInAnonymously();
    }

    _startChat();
  }

  Future<void> _startChat() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final adminId = 'admin_uid'; // Replace with the actual admin UID

    // Check if a chat already exists
    final chatDoc = await _firestore.collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    if (chatDoc.docs.isNotEmpty) {
      _chatId = chatDoc.docs.first.id;
    } else {
      // Create a new chat
      final newChatDoc = await _firestore.collection('chats').add({
        'participants': [userId, adminId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      _chatId = newChatDoc.id;
      
      // Send the initial "Hi Admin" message
      _sendMessage("Hi Admin", isUserMessage: true);
    }

    _loadMessages();
  }

void _sendMessage(String message,
    {bool isUserMessage = true, bool isBotResponse = false, bool isAdminResponse = false, bool isSuggestion = false}) async {
  if (message.isNotEmpty) {
    if (!isSuggestion) {
      final messageData = {
        'text': message,
        'isUserMessage': isUserMessage,
        'isBotResponse': isBotResponse,
        'isAdminResponse': isAdminResponse,
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': FirebaseAuth.instance.currentUser!.uid,
      };

      await _firestore.collection('chats')
          .doc(_chatId)
          .collection('messages')
          .add(messageData);
    }

    _controller.clear();
  }
}



  Future<void> _sendAdminMessage(String message) async {
  if (message.isNotEmpty) {
    final messageData = {
      'text': message,
      'isUserMessage': false,
      'isBotResponse': false,
      'isAdminResponse': true,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': 'admin_uid', // Replace with the actual admin UID
    };

    await _firestore.collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add(messageData);
  }
}


  Future<void> _loadMessages() async {
    _firestore.collection('chats')
        .doc(_chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages.clear();
        for (var doc in snapshot.docs) {
          _messages.add(doc.data());
        }
      });
    });
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
    });
    _startChat();
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
                  isAdminResponse: message['isAdminResponse'] ?? false,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SuggestionsChat(
                  onSendMessage: (message,
                      {bool isUserMessage = true, bool isBotResponse = false, bool isAdminResponse = false}) {
                    _sendMessage(message,
                        isUserMessage: isUserMessage,
                        isBotResponse: isBotResponse,
                        isAdminResponse: isAdminResponse);
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: TextStyle(fontSize: 18.0),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (text) => _sendMessage(text),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => _sendMessage(_controller.text),
                      child: const Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
