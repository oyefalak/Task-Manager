import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/ui/utils/anim/animation_extension.dart';

class FadeBoxTransition extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;
  final double? startAnimation;
  final Function(AnimationController animationController)? onPopCall;

  const FadeBoxTransition({super.key, required this.child, this.onPopCall, this.delay, this.duration, this.startAnimation});

  @override
  ConsumerState<FadeBoxTransition> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<FadeBoxTransition> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: widget.duration ?? 800), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reset();
      _controller.addListener(() {
        setState(() {});
      });
      Future.delayed(Duration(milliseconds: widget.delay ?? 0), () {
        if (_controller.isDisposed == false) {
          _controller.forward(from: widget.startAnimation);
        }
      });
      widget.onPopCall?.call(_controller);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return SizeTransition(
    //   sizeFactor: _animation,
    //   axis: Axis.horizontal,
    //   child: SizeTransition(
    //     sizeFactor: _animation,
    //     axis: Axis.vertical,
    //     child: widget.child,
    //   ),
    // );
    return Transform.scale(
      scale: _animation.value,
      child: widget.child,
    );
  }
}
