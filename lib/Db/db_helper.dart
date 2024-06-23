import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/favoritModel.dart'; // Sesuaikan dengan lokasi dan nama file Anda
import '../Models/playlistModel.dart'; // Sesuaikan dengan lokasi dan nama file Anda
import '../Models/songModel.dart'; // Sesuaikan dengan lokasi dan nama file Anda

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE playlists (
      id $idType,
      name $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE songs (
      id $idType,
      title $textType,
      artist $textType,
      path $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE favorite_songs (
      id $idType,
      song_id INTEGER NOT NULL,
      FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<Playlist> createPlaylist(Playlist playlist) async {
    final db = await instance.database;

    final id = await db.insert('playlists', playlist.toMap());

    // Simpan lagu-lagu ke dalam tabel playlist_songs
    for (var song in playlist.songs) {
      await db.insert('playlist_songs', {
        'playlist_id': id,
        'song_id': song.id,
      });
    }

    return playlist.copy(id: id);
  }

  Future<FavoriteSong> createFavoriteSong(FavoriteSong favoriteSong) async {
    final db = await instance.database;

    final id = await db.insert('favorite_songs', favoriteSong.toMap());

    return favoriteSong.copy(id: id);
  }

  Future<Song> createSong(Song song) async {
    final db = await instance.database;

    final id = await db.insert('songs', song.toMap());
    return song.copy(id: id);
  }

  Future<List<Song>> getSongsInPlaylist(int playlistId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT songs.* FROM songs
      JOIN playlist_songs ON songs.id = playlist_songs.song_id
      WHERE playlist_songs.playlist_id = ?
    ''', [playlistId]);

    return result.map((json) => Song.fromMap(json)).toList();
  }

  Future<List<FavoriteSong>> getAllFavoriteSongs() async {
    final db = await instance.database;

    final result = await db.query('favorite_songs');

    return result.map((json) => FavoriteSong.fromMap(json)).toList();
  }

  Future<int> updatePlaylist(Playlist playlist) async {
    final db = await instance.database;

    // Update informasi playlist
    await db.update(
      'playlists',
      playlist.toMap(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );

    // Hapus semua lagu yang terkait dengan playlist ini
    await db.delete(
      'playlist_songs',
      where: 'playlist_id = ?',
      whereArgs: [playlist.id],
    );

    // Simpan kembali lagu-lagu ke dalam tabel playlist_songs
    for (var song in playlist.songs) {
      await db.insert('playlist_songs', {
        'playlist_id': playlist.id,
        'song_id': song.id,
      });
    }

    return playlist.id!;
  }

  Future<int> deletePlaylist(int id) async {
    final db = await instance.database;

    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFavoriteSong(int id) async {
    final db = await instance.database;

    return await db.delete(
      'favorite_songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await instance.database;

    await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
