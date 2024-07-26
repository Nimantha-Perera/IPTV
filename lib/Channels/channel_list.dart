// lib/channels_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, String>>> getChannels() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? roomUserName = prefs.getString('roomUserName');

  if (roomUserName == null) {
    print('Room username not found in SharedPreferences');
    return [];
  }

  final channelsCollection = firestore.collection('customers').doc(roomUserName).collection('channels');
  
  try {
    final snapshot = await channelsCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Get data as Map<String, dynamic>
      return {
        'title': data['title'] as String, // Explicitly cast to String
        'videoUrl': data['videoUrl'] as String, // Explicitly cast to String
      };
    }).toList();
  } catch (e) {
    print('Error fetching channels: $e');
    return [];
  }
}
