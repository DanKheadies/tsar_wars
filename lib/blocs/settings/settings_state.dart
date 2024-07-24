part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool audioOn;
  final bool musicOn;
  final bool soundsOn;
  final String playerName;

  const SettingsState({
    this.audioOn = false,
    this.musicOn = false,
    this.playerName = '',
    this.soundsOn = false,
  });

  @override
  List<Object> get props => [
        audioOn,
        musicOn,
        playerName,
        soundsOn,
      ];

  SettingsState copyWith({
    bool? audioOn,
    bool? musicOn,
    bool? soundsOn,
    String? playerName,
  }) {
    return SettingsState(
      audioOn: audioOn ?? this.audioOn,
      musicOn: musicOn ?? this.musicOn,
      playerName: playerName ?? this.playerName,
      soundsOn: soundsOn ?? this.soundsOn,
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      audioOn: json['audioOn'] ?? true,
      musicOn: json['musicOn'] ?? true,
      playerName: json['playerName'] ?? '',
      soundsOn: json['soundsOn'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioOn': audioOn,
      'musicOn': musicOn,
      'playerName': playerName,
      'soundsOn': soundsOn,
    };
  }
}
