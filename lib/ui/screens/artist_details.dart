import 'dart:ui';

import 'package:koel_player/models/artist.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/ui/widgets/app_bar.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/song_list_buttons.dart';
import 'package:koel_player/ui/widgets/song_row.dart';
import 'package:koel_player/ui/widgets/sortable_song_list.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:provider/provider.dart';

OrderBy _currentSortOrder = OrderBy.title;

class ArtistDetailsScreen extends StatefulWidget {
  static const routeName = '/artist';

  const ArtistDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  OrderBy _sortOrder = _currentSortOrder;

  @override
  Widget build(BuildContext context) {
    Artist artist = ModalRoute.of(context)!.settings.arguments as Artist;

    return Scaffold(
      body: Consumer<SongProvider>(
        builder: (_, provider, __) {
          List<Song> songs = sortSongs(
            provider.byArtist(artist),
            orderBy: _sortOrder,
          );
          return CustomScrollView(
            slivers: <Widget>[
              AppBar(
                headingText: artist.name,
                actions: [
                  SortButton(
                    options: const {
                      OrderBy.title: 'Song title',
                      OrderBy.album: 'Album',
                      OrderBy.recentlyAdded: 'Recently added',
                    },
                    currentOrder: _sortOrder,
                    onActionSheetActionPressed: (OrderBy order) {
                      _currentSortOrder = order;
                      setState(() => _sortOrder = order);
                    },
                  ),
                ],
                backgroundImage: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: artist.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                coverImage: Hero(
                  tag: "artist-hero-${artist.id}",
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: artist.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SongListButtons(songs: songs)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) => SongRow(
                    song: songs[index],
                    listContext: SongListContext.artist,
                  ),
                  childCount: songs.length,
                ),
              ),
              const BottomSpace(),
            ],
          );
        },
      ),
    );
  }
}
