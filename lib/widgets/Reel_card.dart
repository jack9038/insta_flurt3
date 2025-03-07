import 'package:flutter/material.dart';
import 'package:whitecodel_reels/whitecodel_reels.dart';

class ReelCard extends StatefulWidget {
  final snap;
  const ReelCard({super.key,required this.snap});

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: WhiteCodelReels(
        context: context,
        key: UniqueKey(),
        loader: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        isCaching: true,
        videoList: [
          
        ],
      ),
    );
  }
}
