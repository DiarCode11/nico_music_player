import 'package:flutter/material.dart';
import 'package:nico_music_player/Audio/song_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Play extends StatefulWidget {
  int index;
  final SongModel song;
  final SongService songService;

  Play({required this.index, required this.song, required this.songService});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  bool playStatus = true;
  late SongModel currentSong;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    currentSong = widget.songService.getSongList()[widget.index];
    _registerAudioPlayerListeners();

    playSong(widget.index);
  }

  void _registerAudioPlayerListeners() {
    widget.songService.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    widget.songService.audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });

    playSong(widget.index);
  }

  void playSong(int index) {
    setState(() {
      widget.index = index;
      currentSong = widget.songService.getSongList()[index];
      widget.songService.play(index);
      playStatus = true;
    });
  }

  void pauseSong() {
    setState(() {
      widget.songService.pause();
      playStatus = false;
    });
  }

  void seekTo(double seconds) {
    final newPosition = Duration(seconds: seconds.toInt());
    widget.songService.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Nico Music Play',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(500),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white12,
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.headset,
                color: Colors.white,
                size: 150,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20,)
            ],
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentSong.title.length > 40
                    ? currentSong.title.substring(0, 40) + '...'
                    : currentSong.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          if (duration > Duration.zero)
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                seekTo(value);
              },
              activeColor: Color.fromARGB(255, 5, 162, 186),
              inactiveColor: Colors.grey,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                formatTime(position.inSeconds),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 200),
              Text(
                formatTime(duration.inSeconds),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.skip_previous_rounded,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (widget.index > 0) {
                    playSong(widget.index - 1);
                  }
                },
              ),
              IconButton(
                icon: playStatus
                    ? Icon(
                        Icons.pause_circle_filled_rounded,
                        size: 110,
                        color: Color.fromARGB(255, 5, 162, 186),
                      )
                    : Icon(
                        Icons.play_circle_filled_rounded,
                        size: 110,
                        color: Color.fromARGB(255, 5, 162, 186),
                      ),
                onPressed: () {
                  playStatus ? pauseSong() : playSong(widget.index);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_next_rounded,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (widget.index < widget.songService.getSongList().length - 1) {
                    playSong(widget.index + 1);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }
}
