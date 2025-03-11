import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_resources/firestore_post.dart';
import 'package:instaflurt3/utils/global_variables.dart';
import 'package:video_player/video_player.dart';
import 'package:instaflurt3/utils/colors.dart';

class ReelCard extends StatefulWidget {
  final snap;
  const ReelCard({super.key, required this.snap});

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.snap['reelUrl']))
          ..initialize().then((_) {
            setState(() {
              _isVideoInitialized = true;
              _videoPlayerController.play();
              _videoPlayerController.setLooping(true);
            });
          });
  }

  void _togglePlayVideo() {
    if (_isVideoInitialized) {
      setState(() {
        if (_isPlaying) {
          _videoPlayerController.pause();
          Icon(Icons.pause);
          _isPlaying = false;
        } else {
          _videoPlayerController.play();
          Icon(Icons.play_circle);

          _isPlaying = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Reels",
      home: Scaffold(
        body: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4)
              : EdgeInsets.all(18),
          color: mobileBackgroundColor,
          child: Column(
            children: [
              //Header Section

              //Video section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 1,
                child: GestureDetector(
                  onTap: _togglePlayVideo,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _isVideoInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  _videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      if (!_isPlaying &&
                          _isVideoInitialized) // Show play icon if not playing
                        const Icon(
                          Icons.play_circle,
                          size: 60,
                          color: Colors.white70,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                width: double.maxFinite,
              ),
              Container(
                padding: const EdgeInsets.all(1).copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.snap['profilePic'] ??
                              'default_profile_pic_url',
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap["username"] ?? 'Unknown User',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.snap['description'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding: MediaQuery.of(context).size.width >
                                      webScreenSize
                                  ? EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width / 3)
                                  : EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ["Delete"]
                                  .map((e) => InkWell(
                                        onTap: () async {
                                          await FirestorePost().DeletePost(
                                              widget.snap['ReelId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
