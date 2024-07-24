part of 'player_progress_bloc.dart';

class PlayerProgressState extends Equatable {
  final List<int> levelsFinished;

  const PlayerProgressState({
    this.levelsFinished = const [],
  });

  @override
  List<Object> get props => [
        levelsFinished,
      ];

  PlayerProgressState copyWith({
    List<int>? levelsFinished,
  }) {
    return PlayerProgressState(
      levelsFinished: levelsFinished ?? this.levelsFinished,
    );
  }

  factory PlayerProgressState.fromJson(Map<String, dynamic> json) {
    return PlayerProgressState(
      levelsFinished: (json['levelsFinished'] as List)
          .map((level) => level as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelsFinished': levelsFinished,
    };
  }
}
