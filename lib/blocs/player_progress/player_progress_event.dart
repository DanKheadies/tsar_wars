part of 'player_progress_bloc.dart';

abstract class PlayerProgressEvent extends Equatable {
  const PlayerProgressEvent();

  @override
  List<Object> get props => [];
}

class Reset extends PlayerProgressEvent {}

class SetLevelFinished extends PlayerProgressEvent {
  final int level;
  final int time;

  const SetLevelFinished({
    required this.level,
    required this.time,
  });

  @override
  List<Object> get props => [
        level,
        time,
      ];
}
