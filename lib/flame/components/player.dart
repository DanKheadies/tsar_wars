import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsar_wars/audio/audio.dart';
import 'package:tsar_wars/blocs/settings/settings_bloc.dart';
import 'package:tsar_wars/cubits/cubits.dart';
import 'package:tsar_wars/flame/flame.dart';

enum PlayerCharacterState {
  attacking,
  falling,
  jumping,
  running,
}

class Player extends SpriteAnimationGroupComponent<PlayerCharacterState>
    with
        CollisionCallbacks,
        HasWorldReference<EndlessWorld>,
        HasGameReference<EndlessRunner> {
  final void Function({int amount}) addScore;
  final VoidCallback resetScore;
  // TODO: health

  Player({
    required this.addScore,
    required this.resetScore,
    super.position,
  }) : super(
          size: Vector2.all(256), // 150 // size relative to the world
          anchor: Anchor.center,
          priority: 1,
          // paint: Paint(),
          // scale: Vector2.all(4),
        );
  // The maximum length that the player can jump. Defined in virtual pixels.
  final double jumpLength = 1000; // 600

  // Used to store the last position of the player, so that we later can
  // determine which direction that the player is moving.
  final Vector2 lastPosition = Vector2.zero();

  // The current velocity that the player has that comes from being affected by
  // the gravity. Defined in virtual pixels/s².
  double gravityVelocity = 0;

  // Whether the player is currently in the air, this can be used to restrict
  // movement for example.
  bool get inAir => (position.y + size.y / 2) < world.groundLevel;

  // When the player has velocity pointing downwards it is counted as falling,
  // this is used to set the correct animation for the player.
  bool get isFalling => lastPosition.y < position.y;

  @override
  Future<void> onLoad() async {
    // This defines the different animation states that the player can be in.
    animations = {
      PlayerCharacterState.attacking: await game.loadSpriteAnimation(
        'jedai/jedai_attacking.png',
        SpriteAnimationData.sequenced(
          amount: 4, // # of sequences
          stepTime:
              0.12345 - (0.12345 * game.level.number * 0.2), // animation speed
          // 0.001 is fast; 1.0 is slooow
          // stepTime: 0.12345,
          textureSize: Vector2.all(75), // the size of the sprite PP
        ),
      ),
      // PlayerCharacterState.jumping: await game.loadSpriteAnimation(
      //   'jedai/jedai_jumping.png',
      //   SpriteAnimationData.sequenced(
      //     amount: 6,
      //     stepTime: 0.12345,
      //     textureSize: Vector2.all(64),
      //   ),
      // ),
      PlayerCharacterState.jumping: SpriteAnimation.spriteList(
        [
          await game.loadSprite('jedai/jedai_jumping.png'),
        ],
        stepTime: double.infinity,
      ),
      // PlayerCharacterState.falling: await game.loadSpriteAnimation(
      //   'jedai/jedai_falling.png',
      //   SpriteAnimationData.sequenced(
      //     amount: 6,
      //     stepTime: 0.12345,
      //     textureSize: Vector2.all(128),
      //   ),
      // ),
      PlayerCharacterState.falling: SpriteAnimation.spriteList(
        [
          await game.loadSprite('jedai/jedai_falling.png'),
        ],
        stepTime: double.infinity,
      ),
      PlayerCharacterState.running: await game.loadSpriteAnimation(
        'jedai/jedai_running.png',
        SpriteAnimationData.sequenced(
          amount: 7, // # of sequences
          stepTime:
              0.12345 - (0.12345 * game.level.number * 0.2), // animation speed
          // 0.001 is fast; 1.0 is slooow
          // stepTime: 0.12345,
          textureSize: Vector2.all(64), // the size of the sprite PP
        ),
      ),
    };

    // The starting state will be that the player is running.
    current = PlayerCharacterState.running;
    lastPosition.setFrom(position);

    // When adding a CircleHitbox without any arguments it automatically
    // fills up the size of the component as much as it can without overflowing
    // it.
    add(
      CircleHitbox.relative(
        1,
        parentSize: Vector2.all(215),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // When we are in the air the gravity should affect our position and pull
    // us closer to the ground.
    if (inAir) {
      gravityVelocity += world.gravity * dt;
      position.y += gravityVelocity;
      if (isFalling && current != PlayerCharacterState.attacking) {
        current = PlayerCharacterState.falling;
      }
    }

    final belowGround = position.y + size.y / 2 > world.groundLevel;
    // If the player's new position would overshoot the ground level after
    // updating its position we need to move the player up to the ground level
    // again.
    if (belowGround) {
      position.y = world.groundLevel - size.y / 2;
      gravityVelocity = 0;
      if (current != PlayerCharacterState.attacking) {
        current = PlayerCharacterState.running;
      }
    }

    lastPosition.setFrom(position);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // When the player collides with an obstacle it should lose all its points.
    if (other is Obstacle && current == PlayerCharacterState.attacking) {
      other.removeFromParent();
    } else if (other is Obstacle) {
      game.context.read<AudioCubit>().playSfx(
            SfxType.damage,
            game.context.read<SettingsBloc>().state,
          );
      resetScore();
      add(
        HurtEffect(),
      );
    } else if (other is Point) {
      // When the player collides with a point it should gain a point and remove
      // the `Point` from the game.
      game.context.read<AudioCubit>().playSfx(
            SfxType.score,
            game.context.read<SettingsBloc>().state,
          );
      other.removeFromParent();
      addScore();
    }
    // TODO: enemey
  }

  /// [towards] should be a normalized vector that points in the direction that
  /// the player should jump.
  void jump(Vector2 towards) {
    print('jump');
    current = PlayerCharacterState.jumping;
    // Since `towards` is normalized we need to scale (multiply) that vector by
    // the length that we want the jump to have.
    final jumpEffect = JumpEffect(
      towards..scaleTo(jumpLength),
    );

    // TODO: double jump
    // We only allow jumps when the player isn't already in the air.
    if (!inAir) {
      game.context.read<AudioCubit>().playSfx(
            SfxType.jump,
            game.context.read<SettingsBloc>().state,
          );
      add(jumpEffect);
    } else {
      attack();
    }
  }

  void attack() async {
    print('attack');
    current = PlayerCharacterState.attacking;
    size = Vector2.all(300);

    await Future.delayed(const Duration(seconds: 1));

    current = PlayerCharacterState.running;
    size = Vector2.all(256);
  }
}
