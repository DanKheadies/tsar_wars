import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';
import 'package:tsar_wars/config/config.dart';
import 'package:tsar_wars/models/models.dart';

class GameWinDialog extends StatelessWidget {
  final GameLevel level;
  final int levelCompletedIn;

  const GameWinDialog({
    super.key,
    required this.level,
    required this.levelCompletedIn,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return Center(
      child: NesContainer(
        width: 420,
        height: 300,
        backgroundColor: palette.backgroundPlaySession.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Well done!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You completed level ${level.number} in $levelCompletedIn seconds.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (level.number < gameLevels.length) ...[
              NesButton(
                onPressed: () {
                  context.go('/play/session/${level.number + 1}');
                },
                type: NesButtonType.primary,
                child: const Text('Next level'),
              ),
              const SizedBox(height: 16),
            ],
            NesButton(
              onPressed: () {
                context.go('/play');
              },
              type: NesButtonType.normal,
              child: const Text('Level selection'),
            ),
          ],
        ),
      ),
    );
  }
}
