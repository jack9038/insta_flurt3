import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/utils/global_variables.dart';

class Webscreen extends StatefulWidget {
  const Webscreen({super.key});

  @override
  State<Webscreen> createState() => _WebscreenState();
}

class _WebscreenState extends State<Webscreen> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          "InstaFlurt",
          style: GoogleFonts.robotoSlab(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: const Color.fromRGBO(255, 253, 253, 1),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(Icons.add,
                color: _page == 2 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: Icon(Icons.video_collection,
                color: _page == 3 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(4),
            icon: Icon(Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      )
    );
  }
}
