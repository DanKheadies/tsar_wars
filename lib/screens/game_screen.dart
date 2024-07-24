import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
// import 'package:provider/provider.dart';
// import 'package:tsar_wars/audio/audio.dart';
// import 'package:tsar_wars/blocs/blocs.dart';
// import 'package:tsar_wars/cubits/cubits.dart';
import 'package:tsar_wars/flame/flame.dart';
import 'package:tsar_wars/models/models.dart';
import 'package:tsar_wars/widgets/widgets.dart';

class GameScreen extends StatelessWidget {
  final GameLevel level;

  const GameScreen({
    super.key,
    required this.level,
  });

  static const String winDialogKey = 'win_dialog';
  static const String backButtonKey = 'back_buttton';

  @override
  Widget build(BuildContext context) {
    // final audioController = context.read<AudioController>();

    return Scaffold(
      body: GameWidget<EndlessRunner>(
        key: const Key('play session'),
        game: EndlessRunner(
          context: context,
          level: level,
          // playerProgress: context.read<PlayerProgressBloc>().state,
          // audioCont: audioController,
          // audioCubit: context.read<AudioCubit>(),
          // settingsBloc: context.read<SettingsBloc>(),
        ),
        overlayBuilderMap: {
          backButtonKey: (BuildContext context, EndlessRunner game) {
            return Positioned(
              top: 20,
              right: 10,
              child: NesButton(
                type: NesButtonType.normal,
                onPressed: GoRouter.of(context).pop,
                child: NesIcon(iconData: NesIcons.leftArrowIndicator),
              ),
            );
          },
          winDialogKey: (BuildContext context, EndlessRunner game) {
            return GameWinDialog(
              level: level,
              levelCompletedIn: game.world.levelCompletedIn,
            );
          },
        },
      ),
      // body: BlocBuilder<PlayerProgressBloc, PlayerProgressState>(
      //   builder: (context, state) {
      //     return GameWidget<EndlessRunner>(
      //       key: const Key('play session'),
      //       game: EndlessRunner(
      //         context: context,
      //         level: level,
      //         playerProgress: state,
      //         audioCont: audioController,
      //       ),
      //       overlayBuilderMap: {
      //         backButtonKey: (BuildContext context, EndlessRunner game) {
      //           return Positioned(
      //             top: 20,
      //             right: 10,
      //             child: NesButton(
      //               type: NesButtonType.normal,
      //               onPressed: GoRouter.of(context).pop,
      //               child: NesIcon(iconData: NesIcons.leftArrowIndicator),
      //             ),
      //           );
      //         },
      //         winDialogKey: (BuildContext context, EndlessRunner game) {
      //           return GameWinDialog(
      //             level: level,
      //             levelCompletedIn: game.world.levelCompletedIn,
      //           );
      //         },
      //       },
      //     );
      //   },
      // ),
    );
  }
}
