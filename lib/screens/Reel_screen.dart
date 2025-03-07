import 'package:flutter/material.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:whitecodel_reels/whitecodel_reels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  _ReelScreenState createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reels"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Reels').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Reels Available"));
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ReelItem(
                videoUrl: snapshot.data!.docs[index]['reelUrl'],
                username: snapshot.data!.docs[index]['username'],
                description: snapshot.data!.docs[index]['description'],
                profilePic: snapshot.data!.docs[index]['profilePic'],
              );
            },
          );
        },
      ),
    );
  }
}

class ReelItem extends StatelessWidget {
  final String videoUrl;
  final String username;
  final String description;
  final String profilePic;

  const ReelItem({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.description,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WhiteCodelReels(
          key: UniqueKey(),
          context: context,
          loader: const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
          videoList: [videoUrl],
          isCaching: true,
          builder:
              (context, index, child, videoPlayerController, pageController) {
            return Stack(
              children: [
                child,
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Column(
                    children: [
                      _buildActionButton(Icons.favorite_border, () {
                        /* Like logic */
                      }),
                      _buildActionButton(Icons.comment, () {
                        /* Comment logic */
                      }),
                      _buildActionButton(Icons.share, () {
                        /* Share logic */
                      }),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
