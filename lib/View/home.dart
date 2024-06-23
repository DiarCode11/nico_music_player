import 'package:flutter/material.dart';
import 'package:nico_music_player/Models/playlistModel.dart';
import 'package:nico_music_player/View/favorite.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'play.dart';
import 'playlist/playlist.dart';
import '../Audio/song_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SongModel> _songs = [];
  SongService _songService = SongService();

  String titleSong = '';
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _songService.loadSongs().then((songs) {
      if (mounted) {
        setState(() {
          _songs = songs;
          if (_songs.isNotEmpty) {
            titleSong = _songs[_songService.indexActive()].title;
            isActive = _songService.isActive();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nico Play Music',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child:Container(
                      padding: EdgeInsets.all(10.0),
                      height: 120,
                      width: 180,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 171, 104, 4),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Playlist',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => PlayList()
                        )
                      );
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      height: 120,
                      width: 180,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 25, 134, 193),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Favorite',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Favorite()
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                SizedBox(width: 40,),
                Text(
                  'Daftar Musik', 
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: _songs.isEmpty ? 1 : _songs.length,
                itemBuilder: (context, index) {
                  if (_songs.isEmpty) {
                    return Center(
                        child: Text('Tidak ada lagu ditemukan',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return ListTile(
                      leading: Icon(Icons.music_note, color: Colors.white),
                      title: Text(
                        _songs[index].title,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _songs[index].artist ?? 'Unknown Artist',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        setState(() {
                          titleSong = _songs[index].title;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Play(
                              index: index,
                              song: _songs[index],
                              songService: _songService,
                            ),
                          ),
                        ).then((_) {
                          // Update titleSong when returning from Play page
                          setState(() {
                            if (_songs.isNotEmpty) {
                              titleSong = _songs[_songService.indexActive()].title;
                              isActive = _songService.isActive();
                            }
                          });
                        });
                      },
                    );
                  }
                },
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Play(
                          index: _songService.indexActive(),
                          song: _songs[_songService.indexActive()],
                          songService: _songService,
                        ))).then((_) {
                  // Update titleSong when returning from Play page
                  setState(() {
                    if (_songs.isNotEmpty) {
                      titleSong = _songs[_songService.indexActive()].title;
                      isActive = _songService.isActive();
                    }
                  });
                });
              },
              child: Container(
                height: 120,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[700],
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.music_note,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 240,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _songs.isEmpty
                                          ? 'Tidak ada musik'
                                          : titleSong,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '<unknown>',
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: isActive
                                    ? Icon(
                                        Icons.pause_circle_filled_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.play_circle_filled_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    isActive = !isActive;
                                    if (isActive) {
                                      _songService.play(_songService.indexActive()); // Play music
                                    } else {
                                      _songService.pause(); // Pause music
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_songService.indexActive() < _songService.getSongList().length - 1) {
                                      _songService.play(_songService.indexActive() + 1);
                                      titleSong = _songs[_songService.indexActive()].title;
                                      isActive = true;
                                    }
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

