import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tsar_wars/flame/flame.dart';

enum ObstacleType {
  small,
  tall,
  wide,
}

/// The [Obstacle] component can represent three different types of obstacles
/// that the player can run into.
class Obstacle extends SpriteComponent with HasWorldReference<EndlessWorld> {
  Obstacle.small({super.position})
      : srcSize = Vector2.all(16), // how big
        srcPosition = Vector2.all(32), // where to start on the png
        super(
          size: Vector2.all(150), // space on the screen it takes up (?)
          anchor: Anchor.bottomLeft,
        );

  Obstacle.tall({super.position})
      : srcSize = Vector2(32, 48),
        srcPosition = Vector2.zero(),
        super(
          size: Vector2(200, 250),
          anchor: Anchor.bottomLeft,
        );

  Obstacle.wide({super.position})
      : srcSize = Vector2(32, 16),
        srcPosition = Vector2(48, 32),
        super(
          size: Vector2(200, 100),
          anchor: Anchor.bottomLeft,
        );

  /// Generates a random obstacle of type [ObstacleType].
  factory Obstacle.random({
    Vector2? position,
    Random? random,
    bool canSpawnTall = true,
  }) {
    final values = canSpawnTall
        ? const [ObstacleType.small, ObstacleType.tall, ObstacleType.wide]
        : const [ObstacleType.small, ObstacleType.wide];
    final obstacleType = values.random(random);
    return switch (obstacleType) {
      ObstacleType.small => Obstacle.small(position: position),
      ObstacleType.tall => Obstacle.tall(position: position),
      ObstacleType.wide => Obstacle.wide(position: position),
    };
  }

  final Vector2 srcSize;
  final Vector2 srcPosition;

  @override
  Future<void> onLoad() async {
    // Since all the obstacles reside in the same image, srcSize and srcPosition
    // are used to determine what part of the image that should be used.
    sprite = await Sprite.load(
      'enemies/obstacles.png',
      srcSize: srcSize,
      srcPosition: srcPosition,
    );
    // When adding a RectangleHitbox without any arguments it automatically
    // fills up the size of the component.
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // We need to move the component to the left together with the speed that we
    // have set for the world.
    // `dt` here stands for delta time and it is the time, in seconds, since the
    // last update ran. We need to multiply the speed by `dt` to make sure that
    // the speed of the obstacles are the same no matter the refresh rate/speed
    // of your device.
    position.x -= world.speed * dt;

    // When the component is no longer visible on the screen anymore, we
    // remove it.
    // The position is defined from the upper left corner of the component (the
    // anchor) and the center of the world is in (0, 0), so when the components
    // position plus its size in X-axis is outside of minus half the world size
    // we know that it is no longer visible and it can be removed.
    if (position.x + size.x < -world.size.x / 2) {
      removeFromParent();
    }
  }
}
