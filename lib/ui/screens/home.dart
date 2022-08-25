import 'package:koel_player/constants/dimensions.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/album_provider.dart';
import 'package:koel_player/providers/artist_provider.dart';
import 'package:koel_player/providers/interaction_provider.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/ui/screens/albums.dart';
import 'package:koel_player/ui/screens/artists.dart';
import 'package:koel_player/ui/screens/favorites.dart';
import 'package:koel_player/ui/screens/profile.dart';
import 'package:koel_player/ui/screens/root.dart';
import 'package:koel_player/ui/screens/songs.dart';
import 'package:koel_player/ui/widgets/album_card.dart';
import 'package:koel_player/ui/widgets/artist_card.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/horizontal_card_scroller.dart';
import 'package:koel_player/ui/widgets/simple_song_list.dart';
import 'package:koel_player/ui/widgets/song_card.dart';
import 'package:koel_player/ui/widgets/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late SongProvider songProvider = context.watch();
    late ArtistProvider artistProvider = context.watch();
    late AlbumProvider albumProvider = context.watch();
    late InteractionProvider interactionProvider = context.watch();

    late List<Widget> homeBlocks;

    if (songProvider.songs.isEmpty) {
      homeBlocks = <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Looks like your library is empty. '
                'You can add songs using the web interface or via the '
                'command line.',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const RootScreen(),
                          ),
                        );
                      },
                      child: const Text('Refresh'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];
    } else {
      homeBlocks = <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: SimpleSongList(songs: songProvider.recentlyAdded()),
        ),
        HorizontalCardScroller(
          headingText: 'Most played songs',
          cards: <Widget>[
            ...songProvider.mostPlayed().map((song) => SongCard(song: song)),
            PlaceholderCard(
              icon: CupertinoIcons.music_note,
              onPressed: () => Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => const SongsScreen())),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: SimpleSongList(
            songs: interactionProvider.getRandomFavorites(limit: 5),
            headingText: 'From your favorites',
            onHeaderTap: () => Navigator.of(context)
                .push(CupertinoPageRoute(builder: (_) => const FavoritesScreen())),
          ),
        ),
        HorizontalCardScroller(
          headingText: 'Top albums',
          cards: <Widget>[
            ...albumProvider
                .mostPlayed()
                .map((album) => AlbumCard(album: album)),
            PlaceholderCard(
              icon: CupertinoIcons.music_albums,
              onPressed: () => Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => const AlbumsScreen())),
            ),
          ],
        ),
        HorizontalCardScroller(
          headingText: 'Top artists',
          cards: <Widget>[
            ...artistProvider
                .mostPlayed()
                .map((artist) => ArtistCard(artist: artist)),
            PlaceholderCard(
              icon: CupertinoIcons.music_mic,
              onPressed: () => Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => const ArtistsScreen())),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: SimpleSongList(
            songs: songProvider.leastPlayed(limit: 5),
            headingText: 'Hidden gems',
          ),
        ),
      ]
          .map(
            (widget) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: widget,
            ),
          )
          .toList();
    }

    return Scaffold(
      body: CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: Colors.white,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.black,
              largeTitle: const LargeTitle(text: 'Home'),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const ProfileScreen()),
                ),
                icon: const Icon(
                  CupertinoIcons.person_alt_circle,
                  size: 24,
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate.fixed(homeBlocks)),
            const BottomSpace(height: 128),
          ],
        ),
      ),
    );
  }
}

class MostPlayedSongs extends StatelessWidget {
  final List<Song> songs;
  final BuildContext context;

  const MostPlayedSongs({
    Key? key,
    required this.songs,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: AppDimensions.horizontalPadding),
          child: Heading5(text: 'Most played'),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...songs.expand(
                (song) => [
                  const SizedBox(width: AppDimensions.horizontalPadding),
                  SongCard(song: song),
                ],
              ),
              const SizedBox(width: AppDimensions.horizontalPadding),
              PlaceholderCard(
                icon: CupertinoIcons.music_note,
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(SongsScreen.routeName),
              ),
              const SizedBox(width: AppDimensions.horizontalPadding),
            ],
          ),
        ),
      ],
    );
  }
}
