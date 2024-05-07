import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

// convert duration into min/seconds

  String formatTime(Duration duration) {
    String digitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$digitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: (context, value, child) {
        //get playlits
        final playlist = value.playlist;

        //get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];
        //return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //app bar
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        //title
                        const Text(
                          "P L A Y L I S T",
                        ),
                        //menue button
                        const Icon(
                          Icons.queue_music_rounded,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  //album artwork
                  NueBox(
                    child: Column(
                      children: [
                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(currentSong.albumArtImage),
                        ),

                        //song and artist name
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // song and arist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    currentSong.artistName,
                                  ),
                                ],
                              ),
                              //heart icon
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //start and end time
                              Text(
                                formatTime(value.currentDuration),
                              ),

                              //shuffle icon
                              IconButton(
                                onPressed: () {
                                  value.toggleShuffle();
                                },
                                icon: Icon(
                                  Icons.shuffle,
                                  color: value.isShuffleActivated
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),

                              //repeat icon
                              IconButton(
                                onPressed: () {
                                  value
                                      .loop(); // Assuming `value` is an instance of `PlayListProvider`
                                },
                                icon: Icon(
                                  Icons.repeat,
                                  color: value.isLoopActivated
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                              //end time
                              Text(
                                formatTime(value.totalDuration),
                              ),
                            ],
                          ),
                        ),

                        //song duration progress
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0),
                          ),
                          child: Slider(
                            min: 0,
                            max: max(
                              value.totalDuration.inSeconds.toDouble(),
                              value.currentDuration.inSeconds.toDouble(),
                            ),
                            value: min(
                              value.currentDuration.inSeconds.toDouble(),
                              value.totalDuration.inSeconds.toDouble(),
                            ),
                            activeColor: Colors.black,
                            onChanged: (double double) {
                              //when the user is sliding around
                            },
                            onChangeEnd: (double double) {
                              //sliding has finished go to that position in song duration
                              value.seek(Duration(seconds: double.toInt()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  //playback controls
                  Row(
                    children: [
                      //skip pervious
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playpreviousSong,
                          child: const NueBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NueBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),
                      // skip forword
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NueBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
