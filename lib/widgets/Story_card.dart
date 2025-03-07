import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryCard extends StatefulWidget {
  final snap;
  const StoryCard({super.key, required this.snap});

  @override
  State<StoryCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VideoPlayer(VideoPlayerController.networkUrl(
                widget.snap['videoUrl'] ?? 'default_video_url',
              )),
            ),
          );
        },
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            widget.snap['profilePic'] ?? 'default_profile_pic_url',
          ),
        ),
      ),
    );
  }
}
