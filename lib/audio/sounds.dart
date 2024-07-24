enum SfxType {
  buttonTap,
  damage,
  doubleJump,
  hit,
  jump,
  score,
}

double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.damage:
    case SfxType.doubleJump:
    case SfxType.hit:
    case SfxType.jump:
    case SfxType.score:
      return 0.4;
    case SfxType.buttonTap:
      return 1.0;
  }
}

List<String> soundTypeToFilename(SfxType type) => switch (type) {
      SfxType.buttonTap => const [
          'click1.mp3',
          'click2.mp3',
          'click3.mp3',
          'click4.mp3',
        ],
      SfxType.damage => const [
          'damage1.mp3',
          'damage2.mp3',
        ],
      SfxType.doubleJump => const [
          'double_jump1.mp3',
        ],
      SfxType.hit => const [
          'hit1.mp3',
          'hit2.mp3',
        ],
      SfxType.jump => const [
          'jump1.mp3',
        ],
      SfxType.score => const [
          'score1.mp3',
          'score2.mp3',
        ],
    };
