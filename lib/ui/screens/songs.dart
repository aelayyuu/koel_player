import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/ui/widgets/app_bar.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/song_list_buttons.dart';
import 'package:koel_player/ui/widgets/song_row.dart';
import 'package:koel_player/ui/widgets/sortable_song_list.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:provider/provider.dart';

// Keep track of the sort orders between revisits
OrderBy _currentSortOrder = OrderBy.recentlyAdded;

class SongsScreen extends StatefulWidget {
  static const routeName = '/songs';

  const SongsScreen({Key? key}) : super(key: key);

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  OrderBy _sortOrder = _currentSortOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SongProvider>(
        builder: (_, provider, __) {
          List<Song> songs = sortSongs(provider.songs, orderBy: _sortOrder);

          return CustomScrollView(
            slivers: [
              AppBar(
                headingText: 'All songs',
                actions: [
                  SortButton(
                    options: const {
                      OrderBy.artist: 'Artist',
                      OrderBy.title: 'Song title',
                      OrderBy.recentlyAdded: 'Recently added',
                    },
                    currentOrder: _sortOrder,
                    onActionSheetActionPressed: (OrderBy order) {
                      _currentSortOrder = order;
                      setState(() => _sortOrder = order);
                    },
                  ),
                ],
                coverImage: provider.coverImageStack,
              ),
              SliverToBoxAdapter(child: SongListButtons(songs: songs)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) => SongRow(
                    song: songs[index],
                    listContext: SongListContext.allSongs,
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
