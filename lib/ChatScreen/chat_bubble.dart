import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  final bool isBotResponse;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUserMessage,
    required this.isBotResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Colors.blueAccent
              : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isUserMessage ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isUserMessage ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: MarkdownBody(
          data: message,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isUserMessage ? Colors.white : Colors.black87,
              fontSize: 16.0,
            ),
            strong: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
