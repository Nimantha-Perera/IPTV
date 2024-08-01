import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveChatHistory(List<Map<String, dynamic>> messages) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(messages);
  await prefs.setString('chat_history', jsonString);
}

Future<List<Map<String, dynamic>>> loadChatHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('chat_history');
  if (jsonString != null) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => e as Map<String, dynamic>).toList();
  }
  return [];
}
