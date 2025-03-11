import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_resources/firestore_post.dart';
import 'package:instaflurt3/models/users.dart';
import 'package:instaflurt3/provider/user_provider.dart';
import 'package:instaflurt3/screens/comment_Screen.dart';
import 'package:instaflurt3/screens/profile_screen.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/utils/global_variables.dart';
import 'package:instaflurt3/utils/utils.dart';
import 'package:instaflurt3/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  int commentLen = 0;
  bool _isMounted = true; // Track the mounted state

  @override
  void initState() {
    super.initState();
    getComments();
  }

  @override
  void dispose() {
    _isMounted = false; // Set mounted to false when disposing
    super.dispose();
  }

  void getComments() {
    try {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get()
          .then((snap) {
        if (_isMounted) {
          // Check if the widget is still mounted
          setState(() {
            commentLen = snap.docs.length;
          });
        }
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    // Use safe access with default values

    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 3.2),
      child: Column(
        children: [
          //Header Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                //Gesture detector to see the profile picture
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Image(
                                  image: NetworkImage(
                                    widget.snap['profilePic'] ??
                                        'default_profile_pic_url',
                                  ),
                                )),
                      );
                    },
                    child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.snap['profilePic'] ??
                              ['default_profile_pic_url'],
                        ))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: widget.snap['uid'],
                                      ))),
                          child: Text(
                            widget.snap['username'] ?? ['Unknown User'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
                          padding:
                              MediaQuery.of(context).size.width > webScreenSize
                                  ? EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width / 3)
                                  : EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: ["Delete"]
                              .map((e) => InkWell(
                                    onTap: () async {
                                      await FirestorePost()
                                          .DeletePost(widget.snap['postId']);
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
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          //Image section

          GestureDetector(
            onDoubleTap: () async {
              await FirestorePost().LikePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Center(
                        child:
                            Image(image: NetworkImage(widget.snap['postUrl'])),
                      ),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 457 / 451,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Image.network(
                        // fit: BoxFit.cover,
                        widget.snap['postUrl'],
                      )
                      // Handle the case where postUrl is null
                      ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  duration: Duration(milliseconds: 500),
                  isAnimating: isAnimating,
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Color.fromARGB(192, 240, 41, 41),
                    size: 100,
                  ),
                ),
              )
            ]),
          ),

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                duration: Duration(milliseconds: 500),
                child: IconButton(
                    onPressed: () async {
                      await FirestorePost().LikePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                          )),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            snap: widget.snap,
                          ),
                        ),
                      ),
                  icon: Icon(
                    Icons.comment,
                  )),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                    )),
              ))
            ],
          ),

          //description and number of comments
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap['likes'].length} likes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' ' + widget.snap['description'],
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentLen comments",
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                if (widget.snap['datePublished'] !=
                    null) // Check if datePublished is not null
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:instaflurt3/firebase_resources/firestore_post.dart';
// import 'package:instaflurt3/models/users.dart';
// import 'package:instaflurt3/provider/user_provider.dart';
// import 'package:instaflurt3/screens/comment_Screen.dart';
// import 'package:instaflurt3/screens/profile_screen.dart';
// import 'package:instaflurt3/utils/colors.dart';
// import 'package:instaflurt3/utils/utils.dart';
// import 'package:instaflurt3/widgets/like_animation.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class PostCard extends StatefulWidget {
//   final snap;
//   const PostCard({super.key, required this.snap});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool isAnimating = false;
//   int commentLen = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getComments();
//   }

//   void getComments() {
//     try {
//       FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get()
//           .then((snap) {
//         setState(() {
//           commentLen = snap.docs.length;
//         });
//       });
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser!;
//     return Container(
//       color: mobileBackgroundColor,
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           //Header Section
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16)
//                 .copyWith(right: 0),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                           builder: (context) => Image(
//                                   image: NetworkImage(
//                                 widget.snap['profilePic'],
//                               ))),
//                     );
//                   },
//                   child: CircleAvatar(
//                       radius: 20,
//                       backgroundImage: NetworkImage(
//                           // "https://firebasestorage.googleapis.com/v0/b/instaflurt3.firebasestorage.app/o/profilepic%2FIZAzZca0YjfNPnU2c2jKUzAespz2?alt=media&token=dbc9249d-2e16-4cef-989b-43e0b08dc911"
//                           widget.snap['profilePic'] ?? 'default_profile_pic_url',
//                           )),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 8),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () =>
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => ProfileScreen(
//                                         uid: widget.snap['uid'],
//                                       ))),
//                           child: Text(
//                             widget.snap["username"] ?? 'Unknown User',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => Dialog(
//                         child: ListView(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shrinkWrap: true,
//                           children: ["Delete"]
//                               .map((e) => InkWell(
//                                     onTap: () async {
//                                       await FirestorePost()
//                                           .DeletePost(widget.snap['postId']);
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 12, horizontal: 16),
//                                       child: Text(e),
//                                     ),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                     );
//                   },
//                   icon: Icon(Icons.more_vert),
//                 )
//               ],
//             ),
//           ),
//           //Image section

//           GestureDetector(
//             onDoubleTap: () async {
//               await FirestorePost().LikePost(
//                   widget.snap['postId'], user.uid, widget.snap['likes']);
//               setState(() {
//                 isAnimating = true;
//               });
//             },
//             child: Stack(alignment: Alignment.center, children: [
//               GestureDetector(
//                 onLongPress: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => Image(
//                       image: NetworkImage(
//                           // 'https://firebasestorage.googleapis.com/v0/b/instaflurt3.firebasestorage.app/o/profilepic%2FIZAzZca0YjfNPnU2c2jKUzAespz2?alt=media&token=dbc9249d-2e16-4cef-989b-43e0b08dc911'
//                           widget.snap['postUrl'],
//                           ),
//                       errorBuilder: (BuildContext context, Object exception,
//                           StackTrace? stackTrace) {
//                         print('Error loading image: $exception');
//                         return const Center(child: Icon(Icons.error));
//                       },
//                       loadingBuilder: (BuildContext context, Widget child,
//                           ImageChunkEvent? loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 child: AspectRatio(
//                   aspectRatio: 457 / 451,
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.35,
//                     width: double.infinity,
//                     child: Image.network(
//                       fit: BoxFit.cover,
//                       widget.snap['postUrl'],
//                     ),
//                   ),
//                 ),
//               ),
//               AnimatedOpacity(
//                 duration: Duration(milliseconds: 200),
//                 opacity: isAnimating ? 1 : 0,
//                 child: LikeAnimation(
//                   duration: Duration(milliseconds: 500),
//                   isAnimating: isAnimating,
//                   onEnd: () {
//                     setState(() {
//                       isAnimating = false;
//                     });
//                   },
//                   child: const Icon(
//                     Icons.favorite,
//                     color: Color.fromARGB(192, 240, 41, 41),
//                     size: 100,
//                   ),
//                 ),
//               )
//             ]),
//           ),

//           Row(
//             children: [
//               LikeAnimation(
//                 isAnimating: widget.snap['likes'].contains(user.uid),
//                 smallLike: true,
//                 duration: Duration(milliseconds: 500),
//                 child: IconButton(
//                     onPressed: () async {
//                       await FirestorePost().LikePost(widget.snap['postId'],
//                           user.uid, widget.snap['likes']);
//                     },
//                     icon: widget.snap['likes'].contains(user.uid)
//                         ? Icon(
//                             Icons.favorite,
//                             color: Colors.red,
//                           )
//                         : Icon(
//                             Icons.favorite_border,
//                           )),
//               ),
//               IconButton(
//                   onPressed: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CommentScreen(
//                             snap: widget.snap,
//                           ),
//                         ),
//                       ),
//                   icon: Icon(
//                     Icons.comment,
//                   )),
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.share,
//                 ),
//               ),
//               Expanded(
//                   child: Align(
//                 alignment: Alignment.centerRight,
//                 child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.bookmark_outline,
//                     )),
//               ))
//             ],
//           ),

//           //description and number of comments
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DefaultTextStyle(
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(fontWeight: FontWeight.w800),
//                   child: Text(
//                     "${widget.snap['likes'].length} likes",
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.only(top: 8),
//                   child: RichText(
//                     text: TextSpan(
//                         style: TextStyle(color: primaryColor),
//                         children: [
//                           TextSpan(
//                             text: widget.snap['username'],
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           TextSpan(
//                             text: "  ${widget.snap['description']}",
//                           ),
//                         ]),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       "View all $commentLen comments",
//                       style: TextStyle(fontSize: 16, color: secondaryColor),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     DateFormat.yMMMd()
//                         .format(widget.snap['datePublished'].toDate()),
//                     style: TextStyle(fontSize: 16, color: secondaryColor),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
