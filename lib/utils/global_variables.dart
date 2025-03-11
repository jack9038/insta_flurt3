import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/screens/Reel_screen.dart';

import 'package:instaflurt3/screens/add_post_screen.dart';
import 'package:instaflurt3/screens/feed_screen.dart';
import 'package:instaflurt3/screens/profile_screen.dart';
import 'package:instaflurt3/screens/search_screens.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreens(),
  AddPostScreen(),
  ReelScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
