import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tsar_wars/blocs/blocs.dart';
import 'package:tsar_wars/config/config.dart';
import 'package:tsar_wars/cubits/cubits.dart';
import 'package:tsar_wars/screens/screens.dart';
import 'package:tsar_wars/widgets/widgets.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/banner.png',
                filterQuality: FilterQuality.none,
              ),
              const SizedBox(
                height: 10,
                width: double.infinity,
              ),
              Transform.rotate(
                angle: -0.1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'A Flutter game template.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WobblyButton(
              onPressed: () => GoRouter.of(context).go('/play'),
              child: const Text('Play'),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            WobblyButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            GestureDetector(
              onLongPress: () => context.read<AudioCubit>().stopAllSound(),
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () => context.read<SettingsBloc>().add(
                            ToggleAudio(),
                          ),
                      icon: Icon(
                        state.audioOn ? Icons.volume_up : Icons.volume_off,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            const Text('Built with Flame'),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
