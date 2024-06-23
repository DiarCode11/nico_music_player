class Song {
  int? id;
  String title;
  String artist;
  String path;

  Song({this.id, required this.title, required this.artist, required this.path});

  Song copy({int? id, String? title, String? artist, String? path}) => Song(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        path: path ?? this.path,
      );

  static Song fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      path: map['path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'path': path,
    };
  }

  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artist, path: $path}';
  }
}
