import 'dart:developer' as dev;

import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:tsar_wars/blocs/blocs.dart';
import 'package:tsar_wars/config/config.dart';
import 'package:tsar_wars/cubits/cubits.dart';
import 'package:tsar_wars/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  // kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    // print('listenting for logger');
    print('${record.level.name}: ${record.time}: ${record.message}');
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: Provider(
        create: (context) => Palette(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AudioCubit()..initializeAudio(),
            ),
            BlocProvider(
              create: (context) => PlayerProgressBloc(),
            ),
            BlocProvider(
              create: (context) => SettingsBloc(
                appLifecycleNotifier: context.read<AppLifecycleStateNotifier>(),
                audioCubit: context.read<AudioCubit>(),
              ),
            ),
          ],
          // TODO: convert Palette to ThemeData and feed BrightnessCubit here
          child: Builder(
            builder: (context) {
              final palette = context.watch<Palette>();

              return MaterialApp.router(
                title: 'Endless Runner',
                theme: flutterNesTheme().copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: palette.seed.color,
                    surface: palette.backgroundMain.color,
                  ),
                  textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                    bodyColor: palette.text.color,
                    displayColor: palette.text.color,
                  ),
                ),
                routerConfig: router,
              );
            },
          ),
        ),
      ),
    );
  }
}
