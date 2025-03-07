import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaflurt3/firebase_resources/Firestore_Reel.dart';
import 'package:instaflurt3/firebase_resources/firestore_post.dart';
import 'package:instaflurt3/models/users.dart';
import 'package:instaflurt3/provider/user_provider.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  XFile? _video;
  Uint8List? _file;
  VideoPlayerController? _videoPlayerController; // Add a VideoPlayerController
  bool _isVideoInitialized = false;

  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _videoPlayerController?.dispose(); // Dispose of the controller
  }

  void clearMedia() {
    setState(() {
      _file = null;
      _video = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
      _isVideoInitialized = false;
    });
  }

  void postVideo(
    String uid,
    String username,
    String profilePic,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Future<String> res = FirestoreReel().UploadReel(
          _descriptionController.text, uid, username, profilePic, _video!);
      String result = await res;

      if (result == "success") {
        showSnackBar('Reel Posted Successfully', context);
        setState(() {
          _isLoading = false;
        });
        clearMedia();
      } else {
        showSnackBar(result, context);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(e.toString(), context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void postImage(
    String uid,
    String username,
    String profilePic,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Future<String> res = FirestorePost().uploadPost(
          _descriptionController.text, _file!, uid, username, profilePic);
      String result = await res;
      if (result == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Image Posted Successfully', context);
        clearMedia();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(result, context);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  // Function to select an image or video
  _selectMedia(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Media'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Take a Photo to post'),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ],
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);

                setState(() {
                  _file = file;
                  _isVideoInitialized = false;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('pick An Image to post'),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image),
                    ],
                  ),
                ],
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);

                setState(() {
                  _file = file;
                  _isVideoInitialized = false;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Choose a Video as Reel'),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.video_file),
                    ],
                  ),
                ],
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                XFile? video = await ImagePicker().pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: const Duration(seconds: 30),
                );

                if (video != null) {
                  setState(() {
                    _video = video;
                    _initializeVideoPlayer(video);
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Take a Video as Reel'),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam),
                    ],
                  ),
                ],
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                XFile? video = await ImagePicker().pickVideo(
                  source: ImageSource.camera,
                  maxDuration: const Duration(seconds: 20),
                );

                if (video != null) {
                  setState(() {
                    _video = video;
                    _initializeVideoPlayer(video);
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeVideoPlayer(XFile video) async {
    _videoPlayerController = VideoPlayerController.file(File(video.path));
    await _videoPlayerController!.initialize();
    await _videoPlayerController!.play();
    _videoPlayerController!.setLooping(true);

    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user =
        Provider.of<UserProvider>(context, listen: false).getUser!;

    return (_file == null && _video == null)
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              icon: const Icon(Icons.upload),
              iconSize: 40,
              onPressed: () => _selectMedia(context),
            ),
            Text('Upload Media'),
          ])
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearMedia,
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_file != null) {
                      postImage(user.uid, user.username, user.photoUrl);
                    } else if (_video != null) {
                      postVideo(user.uid, user.username, user.photoUrl);
                    }
                  },
                  child: const Text(
                    'POST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  const Divider(
                    thickness: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none,
                          ),
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: _video != null
                            ? _isVideoInitialized
                                ? VideoPlayer(_videoPlayerController!)
                                : const Center(
                                    child: CircularProgressIndicator())
                            : Image.memory(_file!)),
                  ),
                  const Divider(
                    thickness: 0,
                  ),
                ],
              ),
            ),
          );
  }
}

// // import 'dart:io';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:instaflurt3/firebase_resources/Firestore_Reel.dart';

// // import 'package:instaflurt3/firebase_resources/firestore_post.dart';
// // import 'package:instaflurt3/models/users.dart';
// // import 'package:instaflurt3/provider/user_provider.dart';
// // import 'package:instaflurt3/screens/Reel_screen.dart';
// // import 'package:instaflurt3/utils/colors.dart';
// // import 'package:instaflurt3/utils/utils.dart';
// // import 'package:provider/provider.dart';
// // import 'package:video_player/video_player.dart';

// // class AddPostScreen extends StatefulWidget {
// //   const AddPostScreen({super.key});

// //   @override
// //   State<AddPostScreen> createState() => _AddPostScreenState();
// // }

// // class _AddPostScreenState extends State<AddPostScreen> {
// //   XFile? _video;
// //   Uint8List? _file;

// //   final TextEditingController _descriptionController = TextEditingController();
// //   bool _isLoading = false;

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _descriptionController.dispose();
// //   }

// //   void clearMedia() {
// //     setState(() {
// //       _file = null;
// //       _video = null;
// //     });
// //   }

// //   void postVideo(
// //     String uid,
// //     String username,
// //     String profilePic,
// //   ) async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //     try {
// //       Future<String> res = FirestoreReel().UploadReel(
// //           _descriptionController.text, uid, username, profilePic, _video!);
// //       String result = await res;

// //       if (result == "success") {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         showSnackBar('Reel Posted Successfully', context);
// //         clearMedia();
// //       } else {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         showSnackBar(result, context);
// //       }
// //     } catch (e) {}
// //   }

// //   void postImage(
// //     String uid,
// //     String username,
// //     String profilePic,
// //   ) async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //     try {
// //       Future<String> res = FirestorePost().uploadPost(
// //           _descriptionController.text, _file!, uid, username, profilePic);
// //       String result = await res;
// //       if (result == "success") {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         showSnackBar('Image Posted Successfully', context);
// //         clearMedia();
// //       } else {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         showSnackBar(result, context);
// //       }
// //     } catch (err) {}
// //   }

// //   // Function to select an image or video
// //   _selectMedia(BuildContext context) async {
// //     return showDialog(
// //       context: context,
// //       builder: (context) {
// //         return SimpleDialog(
// //           title: const Text('Select Media'),
// //           children: [
// //             SimpleDialogOption(
// //               padding: const EdgeInsets.all(20),
// //               child: const Text('Take a Photo'),
// //               onPressed: () async {
// //                 Navigator.of(context).pop();
// //                 Uint8List file = await pickImage(ImageSource.camera);

// //                 setState(() {
// //                   _file = file;
// //                 });
// //               },
// //             ),
// //             SimpleDialogOption(
// //               padding: const EdgeInsets.all(20),
// //               child: const Text('Choose from Gallery'),
// //               onPressed: () async {
// //                 Navigator.of(context).pop();
// //                 Uint8List file = await pickImage(ImageSource.gallery);

// //                 setState(() {
// //                   _file = file;
// //                 });
// //               },
// //             ),
// //             SimpleDialogOption(
// //               padding: const EdgeInsets.all(20),
// //               child: const Text('Upload Video as Reel'),
// //               onPressed: () async {
// //                 Navigator.of(context).pop();
// //                 XFile? video = await ImagePicker().pickVideo(
// //                   source: ImageSource.camera,
// //                   maxDuration: const Duration(seconds: 20),
// //                 );

// //                 setState(() {
// //                   _video = video;
// //                 });
// //               },
// //             ),
// //             SimpleDialogOption(
// //               padding: const EdgeInsets.all(20),
// //               child: const Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final User user =
// //         Provider.of<UserProvider>(context, listen: false).getUser!;

// //     return _file == null || _video != null
// //         ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             IconButton(
// //               icon: const Icon(Icons.upload),
// //               iconSize: 40,
// //               onPressed: () => _selectMedia(context),
// //             ),
// //             Text('Upload Media'),
// //           ])
// //         : Scaffold(
// //             appBar: AppBar(
// //               backgroundColor: mobileBackgroundColor,
// //               leading: IconButton(
// //                 onPressed: clearMedia,
// //                 icon: const Icon(Icons.arrow_back),
// //               ),
// //               title: const Text('Post to'),
// //               centerTitle: false,
// //               actions: <Widget>[
// //                 TextButton(
// //                   onPressed: () {
// //                     _file != null || _video != null
// //                         ? postImage(user.uid, user.username, user.photoUrl)
// //                         : postVideo(user.uid, user.username, user.photoUrl);
// //                   },
// //                   child: const Text(
// //                     'POST',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 18,
// //                       color: Colors.blueAccent,
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //             body: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   _isLoading
// //                       ? const LinearProgressIndicator()
// //                       : Padding(padding: EdgeInsets.only(top: 0)),
// //                   const Divider(
// //                     thickness: 0,
// //                   ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       CircleAvatar(
// //                         radius: 30,
// //                         backgroundImage: NetworkImage(user.photoUrl),
// //                       ),
// //                       SizedBox(
// //                         width: MediaQuery.of(context).size.width * 0.45,
// //                         child: TextField(
// //                           controller: _descriptionController,
// //                           decoration: const InputDecoration(
// //                             hintText: 'Write a caption...',
// //                             border: InputBorder.none,
// //                           ),
// //                           maxLines: 5,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(
// //                     height: 300,
// //                     width: double.maxFinite,
// //                     child: AspectRatio(
// //                       aspectRatio: 487 / 451,
// //                       child: _video != null
// //                           ? DecoratedBox(
// //                               decoration: BoxDecoration(color: Colors.black),
// //                               child: VideoPlayer(VideoPlayerController.file(
// //                                   File(_video!.path))))
// //                           : Image.memory(_file!),
// //                     ),
// //                   ),
// //                   const Divider(
// //                     thickness: 0,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //   }
// // }
