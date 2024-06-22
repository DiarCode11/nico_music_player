import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../Models/playlistModel.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'playlist.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE playlists(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            songs TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    final db = await database;
    await db.insert('playlists', {
      'name': playlist.name,
      'songs': playlist.songs.map((file) => file.path).join(',')
    });
  }

  Future<List<Playlist>> getPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('playlists');
    return List.generate(maps.length, (i) {
      List<File> songs = maps[i]['songs'].split(',').map((path) => File(path)).toList();
      return Playlist(name: maps[i]['name'], songs: songs);
    });
  }
}