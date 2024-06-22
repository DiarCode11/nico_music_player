import 'package:audioplayers/audioplayers.dart';

AudioPlayer audioPlayer = AudioPlayer();

bool isPlaying = false;

bool currentStatus() {
  return isPlaying;
}

void play(Source path) async {
  isPlaying = true;
  await audioPlayer.play(path);
}

void pause() async {
  await audioPlayer.pause();
  isPlaying = false;
}