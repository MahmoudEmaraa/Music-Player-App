import 'package:flutter/material.dart';
import 'package:music_player/components/drawer.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get playlist provider
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();

    //get playlist provider
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);
  }

  //go to a song
  void goToSong(int songIndex) {
    //udpate index
    playlistProvider.currentSongIndex = songIndex;

    //navigate to song page

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        title: const Text(
          "P L A Y L I S T",
        ),
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Consumer<PlayListProvider>(builder: (context, value, child) {
          //get the playlist

          final List<Song> playlist = value.playlist;

          //return list view
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              //get each song
              final Song song = playlist[index];

              //return list tile
              return ListTile(
                title: Text(
                  song.songName,
                ),
                subtitle: Text(
                  song.artistName,
                ),
                leading: Image.asset(song.albumArtImage),
                onTap: () => goToSong(index),
              );
            },
          );
        }),
      ),
    );
  }
}
