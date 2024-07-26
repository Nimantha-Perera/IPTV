import 'package:flutter/material.dart';
import 'package:iptv_app/Channels/channel_list.dart';
import 'package:iptv_app/Channels/channels_btn.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // Import the channels list

class ChannelsView extends StatefulWidget {
  const ChannelsView({super.key});

  @override
  State<ChannelsView> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends State<ChannelsView> {
  List<Map<String, String>> btnText = [];
  String? _activeButtonText;
  String? _currentVideoUrl;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    try {
      List<Map<String, String>> channels = await getChannels();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedChannelTitle = prefs.getString('activeChannelTitle');

      setState(() {
        btnText = channels;

        if (savedChannelTitle != null && savedChannelTitle.isNotEmpty) {
          final savedChannel = btnText.firstWhere(
            (channel) => channel['title'] == savedChannelTitle,
            orElse: () => btnText.isNotEmpty ? btnText[0] : {},
          );
          _activeButtonText = savedChannel['title'];
          _currentVideoUrl = savedChannel['videoUrl'];
        } else {
          _activeButtonText = btnText.isNotEmpty ? btnText[0]['title'] : null;
          _currentVideoUrl = btnText.isNotEmpty ? btnText[0]['videoUrl'] : null;
        }

        if (_currentVideoUrl != null) {
          _initializeVideoPlayer(_currentVideoUrl!);
        }
      });
    } catch (e) {
      print('Error loading channels: $e');
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    _videoPlayerController?.dispose();

    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController?.play();
        });
      });
  }

  Future<void> onButtonPressed(String btnText, String videoUrl) async {
    setState(() {
      _activeButtonText = btnText;
      _currentVideoUrl = videoUrl;
      _initializeVideoPlayer(videoUrl);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeChannelTitle', btnText);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 300.0,
            child: SingleChildScrollView(
              child: Column(
                children: btnText.map((channel) {
                  return Channels(
                    btnText: channel['title']!,
                    isActive: _activeButtonText == channel['title'],
                    onButtonPressed: (text) => onButtonPressed(
                      text,
                      channel['videoUrl']!,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _currentVideoUrl != null && _videoPlayerController?.value.isInitialized == true
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : Text(
                      "Select a Channel to Play Video",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
