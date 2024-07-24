import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

part 'player_progress_event.dart';
part 'player_progress_state.dart';

class PlayerProgressBloc
    extends HydratedBloc<PlayerProgressEvent, PlayerProgressState> {
  PlayerProgressBloc() : super(const PlayerProgressState()) {
    on<Reset>(_onReset);
    on<SetLevelFinished>(_onSetLevelFinished);
  }

  void _onReset(
    Reset event,
    Emitter<PlayerProgressState> emit,
  ) {
    emit(
      state.copyWith(
        levelsFinished: const [],
      ),
    );
  }

  void _onSetLevelFinished(
    SetLevelFinished event,
    Emitter<PlayerProgressState> emit,
  ) {
    List<int> updatedLevels = state.levelsFinished.toList();

    if (event.level < state.levelsFinished.length - 1) {
      final currentTime = state.levelsFinished[event.level - 1];
      if (event.time < currentTime) {
        updatedLevels[event.level - 1] = event.time;
        emit(
          state.copyWith(
            levelsFinished: updatedLevels,
          ),
        );
      }
    } else {
      updatedLevels.add(event.time);
      emit(
        state.copyWith(
          levelsFinished: updatedLevels,
        ),
      );
    }
  }

  @override
  PlayerProgressState? fromJson(Map<String, dynamic> json) {
    Logger('PlayerProgress').fine(() => 'Loaded progress: $json');
    // TODO: kIsWeb audioOn should be false (?)
    return PlayerProgressState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PlayerProgressState state) {
    return state.toJson();
  }
}
