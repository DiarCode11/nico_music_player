import 'songModel.dart';

class Playlist {
  int? id;
  String name;
  List<Song> songs; // Atribut ini digunakan untuk menampung lagu-lagu dalam playlist

  Playlist({
    this.id,
    required this.name,
    this.songs = const [], // Defaultnya kosong, bisa diisi saat inisialisasi objek
  });

  Playlist copy({
    int? id,
    String? name,
    List<Song>? songs,
  }) =>
      Playlist(
        id: id ?? this.id,
        name: name ?? this.name,
        songs: songs ?? this.songs,
      );

  static Playlist fromMap(Map<String, dynamic> map, List<Song> songs) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      songs: songs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Playlist{id: $id, name: $name, songs: $songs}';
  }
}
