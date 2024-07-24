import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:tsar_wars/cubits/cubits.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final AudioCubit _audioCubit;
  final ValueNotifier<AppLifecycleState> _appLifecycleNotifier;
  // StreamSubscription<AppLifecycleState>? _appLifeSubscription;

  SettingsBloc({
    required AudioCubit audioCubit,
    required ValueNotifier<AppLifecycleState> appLifecycleNotifier,
  })  : _appLifecycleNotifier = appLifecycleNotifier,
        _audioCubit = audioCubit,
        super(const SettingsState()) {
    on<SetPlayerName>(_onSetPlayerName);
    on<ToggleAudio>(_onToggleAudio);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleSound>(_onToggleSound);

    // _appLifeSubscription = AppLifecycleStateNotifier().value.l
    // TODO: how can I make the app life cycle / state come from a stream
    print('start settings bloc');
    _appLifecycleNotifier.addListener(handleAppLifecycle);
    if (state.audioOn && state.musicOn) {
      if (kIsWeb) {
        Logger('SettingsBloc').info('Start music from init');
      } else {
        _audioCubit.playCurrentSongInPlaylist();
      }
    }
  }

  void handleAppLifecycle() {
    // print('tirgger lifecycle');
    switch (_appLifecycleNotifier.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _audioCubit.stopAllSound();
      case AppLifecycleState.resumed:
        if (state.audioOn && state.musicOn) {
          _audioCubit.startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _onSetPlayerName(
    SetPlayerName event,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(
        playerName: event.name,
      ),
    );
  }

  void _onToggleAudio(
    ToggleAudio event,
    Emitter<SettingsState> emit,
  ) {
    Logger('SettingsBloc').fine('audioOn changed to ${state.audioOn}');
    if (state.audioOn) {
      _audioCubit.stopAllSound();
    } else {
      if (state.musicOn) {
        _audioCubit.startOrResumeMusic();
      }
    }

    emit(
      state.copyWith(
        audioOn: !state.audioOn,
      ),
    );
  }

  void _onToggleMusic(
    ToggleMusic event,
    Emitter<SettingsState> emit,
  ) {
    if (!state.musicOn) {
      if (state.audioOn) {
        _audioCubit.startOrResumeMusic();
      }
    } else {
      _audioCubit.state.musicPlayer.pause();
    }

    emit(
      state.copyWith(
        musicOn: !state.musicOn,
      ),
    );
  }

  void _onToggleSound(
    ToggleSound event,
    Emitter<SettingsState> emit,
  ) {
    for (final player in _audioCubit.state.sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }

    emit(
      state.copyWith(
        soundsOn: !state.soundsOn,
      ),
    );
  }

  @override
  Future<void> close() {
    _appLifecycleNotifier.removeListener(handleAppLifecycle);
    _audioCubit.dispose();
    return super.close();
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    Logger('SettingsController').fine(() => 'Loaded settings: $json');
    // TODO: kIsWeb audioOn should be false (?)
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
