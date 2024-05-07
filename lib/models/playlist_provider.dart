import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlayListProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Died Once",
      artistName: "Yeat",
      albumArtImage: "assets/images/yeat_cover.jpg",
      audioPath: "audio/DiedOnce.mp3",
    ),
    Song(
      songName: "EL MABDA2",
      artistName: "Marwan Pablo",
      albumArtImage: "assets/images/Elmabda2_cover.jpg",
      audioPath: "audio/ELMABDA2.mp3",
    ),
    Song(
      songName: "Paris",
      artistName: "ZIAD ZAZA",
      albumArtImage: "assets/images/zaza_cover.jpg",
      audioPath: "audio/ZIADZAZAPARIS.mp3",
    ),
  ];
//currnet song index
  int? _currentSongIndex;

//audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

//loop
  bool _isLoopActivated = false;
  bool get isLoopActivated => _isLoopActivated;

//shuffle confirmation
  bool _isShuffleActivated = false;
  bool get isShuffleActivated => _isShuffleActivated;

//shuffle
  List<Song> _shuffledPlaylist = [];

//duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

//constructor
  PlayListProvider() {
    listenToDuration();
  }

//inatial not playing
  bool _isPlaying = false;
//play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

//pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

//resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

// pause or resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

//loop the song
  void loop() {
    _isLoopActivated = !_isLoopActivated;
    _audioPlayer.setReleaseMode(
        _isLoopActivated ? ReleaseMode.loop : ReleaseMode.release);
    notifyListeners();
  }

//shuffle the playlist
  void toggleShuffle() {
    _isShuffleActivated = !_isShuffleActivated;
    if (_isShuffleActivated) {
      _shuffledPlaylist = List.of(_playlist)..shuffle();
      currentSongIndex =
          _shuffledPlaylist.indexOf(_playlist[_currentSongIndex!]);
    } else {
      _shuffledPlaylist = [];
    }
    notifyListeners();
  }

// seek to postion in current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

// play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to the next song if its not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if its not the last song loop back to first song
        currentSongIndex = 0;
      }
    }
  }

// play pervious song
  void playpreviousSong() async {
    //if more than 2 seconds have passed , restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    //if it within 2 seconds of the song go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if its not the first song loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

// listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
//dispose audio player

//getters

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  //setters

  set currentSongIndex(int? newIndex) {
    // to update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    //update
    notifyListeners();
  }
}
