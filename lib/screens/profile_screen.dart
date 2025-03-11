import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_resources/authentication.dart';
import 'package:instaflurt3/firebase_resources/firestore_post.dart';
import 'package:instaflurt3/models/users.dart' as model;
import 'package:instaflurt3/provider/user_provider.dart';
import 'package:instaflurt3/screens/login_screen.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/utils/global_variables.dart';
import 'package:instaflurt3/utils/utils.dart';
import 'package:instaflurt3/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var UserData = {};
  bool _isLoading = false;
  int postLen = 0;
  int followerLen = 0;
  int followingLen = 0;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      followerLen = userSnap.data()!['followers'].length;
      followingLen = userSnap.data()!['following'].length;
      _isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;

      UserData = userSnap.data()!;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user =
        Provider.of<UserProvider>(context, listen: false).getUser!;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amberAccent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(UserData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: MediaQuery.of(context).size.width > webScreenSize
                      ? EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 4)
                      : const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).canPop()
                                  ? Navigator.of(context).pop()
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Center(
                                          child: Image(
                                            image: NetworkImage(
                                                UserData['photoUrl']),
                                          ),
                                        ),
                                      ),
                                    );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              backgroundImage: NetworkImage(
                                UserData['photoUrl'],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'Posts'),
                                    buildStatColumn(followerLen, 'Followers'),
                                    buildStatColumn(followingLen, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            function: () async {
                                              await Authentication().signOut();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor,
                                          )
                                        : _isFollowing
                                            ? FollowButton(
                                                function: () async {
                                                  await FirestorePost()
                                                      .FollowUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['uid']);
                                                  setState(() {
                                                    _isFollowing = false;
                                                    followerLen--;
                                                  });
                                                },
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: primaryColor,
                                              )
                                            : FollowButton(
                                                function: () async {
                                                  await FirestorePost()
                                                      .FollowUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['uid']);
                                                  setState(() {
                                                    _isFollowing = true;
                                                    followerLen++;
                                                  });
                                                },
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                borderColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          UserData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(UserData['bio']),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),

                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    }
                    if (!snapshot.hasData ||
                        (snapshot.data! as dynamic).docs.isEmpty) {
                      return Center(
                          child: Text(
                        'No posts yet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ));
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Image(
                                      image: NetworkImage(snap['postUrl'])))),
                          child: Container(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // FutureBuilder(future: FirebaseFirestore.instance.collection('Reels').where('uid', isEqualTo: widget.uid).get(), builder: )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4, right: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
