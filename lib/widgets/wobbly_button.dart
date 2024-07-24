import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class WobblyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const WobblyButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  State<WobblyButton> createState() => _WobblyButtonState();
}

class _WobblyButtonState extends State<WobblyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        controller.repeat();
      },
      onExit: (event) {
        controller.stop(canceled: false);
      },
      child: RotationTransition(
        turns: controller.drive(const CustomSineTween(0.005)),
        child: NesButton(
          type: NesButtonType.primary,
          onPressed: widget.onPressed,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CustomSineTween extends Animatable<double> {
  final double maxExtent;

  const CustomSineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
