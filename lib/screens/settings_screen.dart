import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tsar_wars/blocs/blocs.dart';
import 'package:tsar_wars/config/config.dart';
import 'package:tsar_wars/screens/screens.dart';
import 'package:tsar_wars/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundSettings.color,
      body: ResponsiveScreen(
        squarishMainArea: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: [
                gap,
                const Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                  ),
                ),
                gap,
                NameChangeLine(
                  name: state.playerName,
                ),
                SettingsLine(
                  title: 'Sound FX',
                  icon: Icon(
                    state.soundsOn ? Icons.graphic_eq : Icons.volume_off,
                  ),
                  onSelected: () => context.read<SettingsBloc>().add(
                        ToggleSound(),
                      ),
                ),
                SettingsLine(
                  title: 'Music',
                  icon: Icon(
                    state.musicOn ? Icons.music_note : Icons.music_off,
                  ),
                  onSelected: () => context.read<SettingsBloc>().add(
                        ToggleMusic(),
                      ),
                ),
                SettingsLine(
                  title: 'Reset progress',
                  icon: const Icon(Icons.delete),
                  onSelected: () {
                    context.read<PlayerProgressBloc>().add(
                          Reset(),
                        );

                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Player progress has been reset.'),
                      ),
                    );
                  },
                ),
                gap,
              ],
            );
          },
        ),
        rectangularMenuArea: WobblyButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
