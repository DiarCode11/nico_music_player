import 'songModel.dart'; // Pastikan model Song sudah diimpor

class FavoriteSong {
  int? id;
  Song song;

  FavoriteSong({
    this.id,
    required this.song,
  });

  FavoriteSong copy({
    int? id,
    Song? song,
  }) =>
      FavoriteSong(
        id: id ?? this.id,
        song: song ?? this.song,
      );

  static FavoriteSong fromMap(Map<String, dynamic> map) {
    return FavoriteSong(
      id: map['id'],
      song: Song.fromMap(map['song']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'song': song.toMap(),
    };
  }

  @override
  String toString() {
    return 'FavoriteSong{id: $id, song: $song}';
  }
}
