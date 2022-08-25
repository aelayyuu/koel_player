import 'package:koel_player/models/album.dart';
import 'package:koel_player/models/artist.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/album_provider.dart';
import 'package:koel_player/providers/artist_provider.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/utils/api_request.dart';
import 'package:flutter/foundation.dart';

class SearchResult {
  List<Song> songs;
  List<Artist> artists;
  List<Album> albums;

  SearchResult({
    required this.songs,
    required this.artists,
    required this.albums,
  });
}

class SearchProvider with ChangeNotifier {
  final SongProvider _songProvider;
  final AlbumProvider _albumProvider;
  final ArtistProvider _artistProvider;

  SearchProvider({
    required songProvider,
    required artistProvider,
    required albumProvider,
  })  : _songProvider = songProvider,
        _artistProvider = artistProvider,
        _albumProvider = albumProvider;

  Future<SearchResult> searchExcerpts({required String keywords}) async {
    var results = await get('search?q=$keywords');
    List<String> songIds = results['results']['songs'].cast<String>();
    List<int> artistIds = results['results']['artists'].cast<int>();
    List<int> albumIds = results['results']['albums'].cast<int>();

    return SearchResult(
      songs: _songProvider.byIds(songIds),
      artists: _artistProvider.byIds(artistIds),
      albums: _albumProvider.byIds(albumIds),
    );
  }
}
