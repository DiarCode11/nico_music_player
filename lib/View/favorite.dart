import 'package:flutter/material.dart';
import '../Db/db_helper.dart'; // Sesuaikan dengan lokasi dan nama file Anda
import '../Models/favoritModel.dart'; // Sesuaikan dengan lokasi dan nama file Anda

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  Future<List<FavoriteSong>>? _favoriteSongsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteSongsFuture = _loadFavoriteSongs();
  }

  Future<List<FavoriteSong>> _loadFavoriteSongs() async {
    try {
      List<FavoriteSong> favoriteSongs = await DatabaseHelper.instance.getAllFavoriteSongs();
      print('Isi dari favorit song tidak ada');
      return favoriteSongs;
    } catch (e) {
      print('Error loading favorite songs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Favorite Music',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<FavoriteSong>>(
        future: _favoriteSongsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading favorite songs'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              // child: Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.music_off_sharp,
              //           size: 110,
              //           color: Colors.white24,
              //       ),
              //       Text(
              //         'Tidak ada musik favorit',
              //         style: TextStyle(
              //           color: Colors.white
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TheFatRat - Monody (feat. Laura Brehm)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('<unknown>', style: TextStyle(fontSize: 14, color: Colors.white24)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('bear bear & friends - NUMB (LYRIC VIDEO)_70k', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('<unknown>', style: TextStyle(fontSize: 14, color: Colors.white24)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            List<FavoriteSong> favoriteSongs = snapshot.data!;
            // Tampilkan daftar lagu favorit
            return ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                FavoriteSong favoriteSong = favoriteSongs[index];
                return ListTile(
                  title: Text(favoriteSong.song.title),
                  subtitle: Text(favoriteSong.song.artist),
                  // Tambahkan fungsi hapus atau tindakan lain di sini jika diperlukan
                );
              },
            );
          }
        },
      ),
    );
  }
}
