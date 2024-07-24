class GameLevel {
  final bool canSpawnTall;
  final int number;
  final int winScore;

  const GameLevel({
    required this.canSpawnTall,
    required this.number,
    required this.winScore,
  });
}

const List<GameLevel> gameLevels = [
  GameLevel(
    number: 1,
    winScore: 3,
    canSpawnTall: false,
  ),
  GameLevel(
    number: 2,
    winScore: 5,
    canSpawnTall: true,
  ),
];
