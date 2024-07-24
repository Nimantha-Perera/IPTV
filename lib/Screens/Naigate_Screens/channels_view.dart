import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:iptv_app/Channels/channels_btn.dart'; // Update this path if necessary

class ChannelsView extends StatefulWidget {
  const ChannelsView({super.key});

  @override
  State<ChannelsView> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends State<ChannelsView> {
  final List<Map<String, String>> btnText = [
    {
      "title": "Channel 1",
      "videoUrl": "https://firebasestorage.googleapis.com/v0/b/portfolio-3c3aa.appspot.com/o/0612.mp4?alt=media&token=1b203dc2-744d-4be5-a14f-53d206f63568" // Example M3U8 URL
    },
    {"title": "Channel 2", "videoUrl": "https://example.com/playlist2.m3u8"},
    {"title": "Channel 3", "videoUrl": "https://example.com/playlist3.m3u8"},
    // Add more channels as needed
  ];

  String? _activeButtonText;
  String? _currentVideoUrl;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Initialize with default channel
    _activeButtonText = btnText[0]['title'];
    _currentVideoUrl = btnText[0]['videoUrl'];
    _initializeVideoPlayer(_currentVideoUrl!);
  }

  void _initializeVideoPlayer(String videoUrl) {
    // Dispose of previous controller if it exists
    _videoPlayerController?.dispose();

    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController?.play();
        });
      });
  }

  void onButtonPressed(String btnText, String videoUrl) {
    setState(() {
      _activeButtonText = btnText;
      _currentVideoUrl = videoUrl;
      _initializeVideoPlayer(videoUrl); // Initialize new video
    });
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
            width: 300.0, // Set the desired width here
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
