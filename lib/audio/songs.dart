class Song {
  final String filename;
  final String name;
  final String? artist;

  const Song(
    this.filename,
    this.name, {
    this.artist,
  });

  @override
  String toString() => 'Song<$filename>';
}

const List<Song> songs = [
  Song(
    'Gatsu.wav',
    'Gatsu',
    artist: 'Daco Taco Flame',
  ),
];
