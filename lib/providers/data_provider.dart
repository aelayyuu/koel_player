import 'package:koel_player/providers/album_provider.dart';
import 'package:koel_player/providers/artist_provider.dart';
import 'package:koel_player/providers/playlist_provider.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/utils/api_request.dart';
import 'package:flutter/widgets.dart';

class DataProvider with ChangeNotifier {
  final SongProvider _songProvider;
  final AlbumProvider _albumProvider;
  final ArtistProvider _artistProvider;
  final PlaylistProvider _playlistProvider;

  DataProvider({
    required SongProvider songProvider,
    required AlbumProvider albumProvider,
    required ArtistProvider artistProvider,
    required PlaylistProvider playlistProvider,
  })  : _songProvider = songProvider,
        _albumProvider = albumProvider,
        _artistProvider = artistProvider,
        _playlistProvider = playlistProvider;

  Future<void> init(BuildContext context) async {
    final Map<String, dynamic> data = await get('data');

    await _artistProvider.init(data['artists']);
    await _albumProvider.init(data['albums']);

    await _songProvider.init(data['songs']);
    _songProvider.initInteractions(data['interactions']);

    await _playlistProvider.init(data['playlists']);
  }
}
