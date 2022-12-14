import 'package:koel_player/models/album.dart';
import 'package:koel_player/models/artist.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/album_provider.dart';
import 'package:koel_player/providers/artist_provider.dart';
import 'package:koel_player/ui/widgets/app_bar.dart';
import 'package:koel_player/values/parse_result.dart';
import 'package:flutter/foundation.dart';

import 'cache_provider.dart';

ParseResult parseSongs(List<dynamic> data) {
  ParseResult result = ParseResult();
  for (var json in data) {
    result.add(Song.fromJson(json), json['id']);
  }

  return result;
}

class SongProvider {
  late ArtistProvider artistProvider;
  late AlbumProvider albumProvider;
  late CacheProvider cacheProvider;
  late CoverImageStack coverImageStack;

  late List<Song> _songs;
  late Map<String, Song> _index;

  SongProvider({
    required this.artistProvider,
    required this.albumProvider,
    required this.cacheProvider,
  });

  Future<void> init(List<dynamic> songData) async {
    ParseResult result = await compute(parseSongs, songData);
    _songs = result.collection.cast();
    _index = result.index.cast();

    for (Song song in _songs) {
      song
        ..artist = artistProvider.byId(song.artistId)
        ..album = albumProvider.byId(song.albumId);

      if (await cacheProvider.has(song: song)) {
        cacheProvider.songs.add(song);
      }
    }

    coverImageStack = CoverImageStack(songs: _songs);
  }

  void initInteractions(List<dynamic> interactionData) {
    for (var interaction in interactionData) {
      Song song = byId(interaction['song_id']);
      song
        ..liked = interaction['liked']
        ..playCount = interaction['play_count']
        ..artist.playCount += song.playCount
        ..album.playCount += song.playCount;
    }
  }

  List<Song> recentlyAdded({int limit = 5}) {
    List<Song> clone = List<Song>.from(_songs);
    clone.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return clone.take(limit).toList();
  }

  List<Song> mostPlayed({int limit = 15}) {
    List<Song> clone = List<Song>.from(_songs);
    clone.sort((a, b) => b.playCount.compareTo(a.playCount));
    return clone.take(limit).toList();
  }

  List<Song> leastPlayed({int limit = 15}) {
    List<Song> clone = List<Song>.from(_songs);
    clone.sort((a, b) => a.playCount.compareTo(b.playCount));
    return clone.take(limit).toList();
  }

  Song byId(String id) => _index[id]!;

  Song? tryById(String id) => _index[id];

  List<Song> byIds(List<String> ids) {
    List<Song> songs = [];

    for (var id in ids) {
      if (_index.containsKey(id)) {
        songs.add(_index[id]!);
      }
    }

    return songs;
  }

  List<Song> byArtist(Artist artist) =>
      _songs.where((song) => song.artist == artist).toList();

  List<Song> byAlbum(Album album) =>
      _songs.where((song) => song.album == album).toList();

  List<Song> favorites() => _songs.where((song) => song.liked).toList();

  List<Song> get songs => _songs;
}
