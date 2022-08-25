import 'package:koel_player/models/album.dart';
import 'package:koel_player/models/artist.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/ui/screens/add_to_playlist.dart';
import 'package:koel_player/ui/screens/album_details.dart';
import 'package:koel_player/ui/screens/albums.dart';
import 'package:koel_player/ui/screens/artist_details.dart';
import 'package:koel_player/ui/screens/artists.dart';
import 'package:koel_player/ui/screens/create_playlist_sheet.dart';
import 'package:koel_player/ui/screens/data_loading.dart';
import 'package:koel_player/ui/screens/downloaded.dart';
import 'package:koel_player/ui/screens/favorites.dart';
import 'package:koel_player/ui/screens/home.dart';
import 'package:koel_player/ui/screens/initial.dart';
import 'package:koel_player/ui/screens/library.dart';
import 'package:koel_player/ui/screens/login.dart';
import 'package:koel_player/ui/screens/now_playing.dart';
import 'package:koel_player/ui/screens/playlist_details.dart';
import 'package:koel_player/ui/screens/playlists.dart';
import 'package:koel_player/ui/screens/profile.dart';
import 'package:koel_player/ui/screens/queue.dart';
import 'package:koel_player/ui/screens/root.dart';
import 'package:koel_player/ui/screens/search.dart';
import 'package:koel_player/ui/screens/song_action_sheet.dart';
import 'package:koel_player/ui/screens/songs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter();

  static Map<String, Widget Function(BuildContext)> routes = {
    InitialScreen.routeName: (_) => const InitialScreen(),
    LoginScreen.routeName: (_) => const LoginScreen(),
    RootScreen.routeName: (_) => const RootScreen(),
    HomeScreen.routeName: (_) => const HomeScreen(),
    SearchScreen.routeName: (_) => const SearchScreen(),
    LibraryScreen.routeName: (_) => const LibraryScreen(),
    FavoritesScreen.routeName: (_) => const FavoritesScreen(),
    PlaylistsScreen.routeName: (_) => const PlaylistsScreen(),
    SongsScreen.routeName: (_) => const SongsScreen(),
    ArtistsScreen.routeName: (_) => const ArtistsScreen(),
    AlbumsScreen.routeName: (_) => const AlbumsScreen(),
    AlbumDetailsScreen.routeName: (_) => const AlbumDetailsScreen(),
    ArtistDetailsScreen.routeName: (_) => const ArtistDetailsScreen(),
    PlaylistDetailsScreen.routeName: (_) => const PlaylistDetailsScreen(),
    QueueScreen.routeName: (_) => const QueueScreen(),
    AddToPlaylistScreen.routeName: (_) => const AddToPlaylistScreen(),
    ProfileScreen.routeName: (_) => const ProfileScreen(),
    DataLoadingScreen.routeName: (_) => const DataLoadingScreen(),
    DownloadedScreen.routeName: (_) => const DownloadedScreen(),
  };

  Future<void> gotoAlbumDetailsScreen(
    BuildContext context, {
    required Album album,
  }) async {
    await Navigator.of(context).push(CupertinoPageRoute(
      builder: (_) => const AlbumDetailsScreen(),
      settings: RouteSettings(arguments: album),
    ));
  }

  Future<void> gotoArtistDetailsScreen(
    BuildContext context, {
    required Artist artist,
  }) async {
    await Navigator.of(context).push(CupertinoPageRoute(
      builder: (_) => const ArtistDetailsScreen(),
      settings: RouteSettings(arguments: artist),
    ));
  }

  Future<void> openNowPlayingScreen(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const NowPlayingScreen(),
        );
      },
    );
  }

  Future<void> showCreatePlaylistSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const CreatePlaylistSheet(),
        );
      },
    );
  }

  Future<void> showActionSheet(
    BuildContext context, {
    required Song song,
  }) async {
    showModalBottomSheet<void>(
      useRootNavigator: true, // covering everything else
      context: context,
      isScrollControlled: true,
      builder: (_) => SongActionSheet(song: song),
    );
  }
}
