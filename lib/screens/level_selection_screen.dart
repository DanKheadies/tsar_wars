import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:tsar_wars/audio/audio.dart';
import 'package:tsar_wars/blocs/blocs.dart';
import 'package:tsar_wars/config/config.dart';
import 'package:tsar_wars/cubits/cubits.dart';
import 'package:tsar_wars/models/models.dart';
import 'package:tsar_wars/widgets/widgets.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levelTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.4,
        );
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection.color,
      floatingActionButton: WobblyButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        child: const Text('Menu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select level',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 16),
                  NesButton(
                    type: NesButtonType.normal,
                    child: NesIcon(
                      iconData: NesIcons.questionMark,
                    ),
                    onPressed: () {
                      NesDialog.show(
                        context: context,
                        builder: (_) => const InstructionsDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: SizedBox(
              width: 450,
              child: BlocBuilder<PlayerProgressBloc, PlayerProgressState>(
                builder: (context, state) {
                  return ListView(
                    children: [
                      for (final level in gameLevels)
                        ListTile(
                          enabled:
                              state.levelsFinished.length >= level.number - 1,
                          onTap: () {
                            context.read<AudioCubit>().playSfx(
                                  SfxType.buttonTap,
                                  context.read<SettingsBloc>().state,
                                );

                            GoRouter.of(context)
                                .go('/play/session/${level.number}');
                          },
                          leading: Text(
                            level.number.toString(),
                            style: levelTextStyle,
                          ),
                          title: Row(
                            children: [
                              Text(
                                'Level #${level.number}',
                                style: levelTextStyle,
                              ),
                              if (state.levelsFinished.length <
                                  level.number - 1)
                                ...[],
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
