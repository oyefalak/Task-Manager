import 'package:flutter/animation.dart';

extension AnimationExtension on AnimationController {
  bool get isDisposed {
    return toStringDetails().toLowerCase().contains('dispose');
  }
}
