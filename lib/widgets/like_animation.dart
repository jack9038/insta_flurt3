import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isAnimating;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation(
      {super.key,
      required this.child,
      required this.duration,
      required this.isAnimating,
      this.onEnd,
      this.smallLike = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

startAnimation()async{
  await controller.forward();
  await controller.reverse();
  await Future.delayed(const Duration(milliseconds: 100),);

  if(widget.onEnd != null){
    widget.onEnd!();
  }
}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
