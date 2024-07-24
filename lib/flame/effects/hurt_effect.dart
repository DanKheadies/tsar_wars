import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:tsar_wars/flame/flame.dart';

class HurtEffect extends Component with ParentIsA<Player> {
  @override
  void onMount() {
    super.onMount();
    const effectTime = 0.5;
    parent.addAll(
      [
        RotateEffect.by(
          pi * 2,
          EffectController(
            duration: effectTime,
            curve: Curves.easeInOut,
          ),
        ),
        MoveByEffect(
          Vector2(0, -400),
          EffectController(
            duration: effectTime,
            curve: Curves.easeInOut,
          ),
          onComplete: removeFromParent,
        ),
        ColorEffect(
          Colors.white,
          EffectController(
            duration: effectTime / 8,
            alternate: true,
            repeatCount: 2,
          ),
          opacityTo: 0.9,
        ),
      ],
    );
  }
}
