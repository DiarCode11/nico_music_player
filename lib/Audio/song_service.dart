import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> _songs = [];
  int _indexActive = 0;
  bool _isActive = false;

  Future<List<SongModel>> loadSongs() async {
    await _checkPermissions();
    _songs = await _audioQuery.querySongs();
    return _songs;
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void play(int index) async {
    _isActive = true;
    _indexActive = index;
    String path = _songs[index].data;
    Source audioSource = DeviceFileSource(path);

    print('indeks aktif: ${_indexActive}');
    await _audioPlayer.play(audioSource);
  }

  void pause() async {
    _isActive = false;
    await _audioPlayer.pause();
  }

  void resume() async {
    _isActive = true;
    await _audioPlayer.resume();
  }

  void stop() async {
    _isActive = false;
    await _audioPlayer.stop();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  int indexActive() {
    return _indexActive;
  }

  bool isActive() {
    return _isActive;
  }

  List<SongModel> getSongList() {
    return _songs;
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}
