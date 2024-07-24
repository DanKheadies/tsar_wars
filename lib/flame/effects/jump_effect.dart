import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class JumpEffect extends MoveByEffect {
  JumpEffect(Vector2 offset)
      : super(
          offset,
          EffectController(
            duration: 0.3,
            curve: Curves.ease,
          ),
        );
}
