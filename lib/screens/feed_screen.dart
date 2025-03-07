import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:instaflurt3/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

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
            onPressed: () {
              // Handle message button press
            },
            icon: const Icon(Icons.message_rounded),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          // Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          // Display posts if data is available
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:instaflurt3/utils/colors.dart';
// import 'package:instaflurt3/widgets/post_card.dart';

// class FeedScreen extends StatelessWidget {
//   const FeedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: Text(
//           "InstaFlurt",
//           style: GoogleFonts.robotoSlab(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               fontStyle: FontStyle.italic,
//               color: Color.fromRGBO(255, 253, 253, 1)),
//         ), //InstFlurt icon
//         actions: [
//           IconButton(
//               onPressed: () {}, icon: Icon(Icons.message_rounded)) // pending
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .orderBy('datePublished', descending: true)
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             );
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) => PostCard(
//               snap: snapshot.data!.docs[index].data(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
