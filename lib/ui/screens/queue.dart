import 'package:flutter/foundation.dart';
import 'package:koel_player/providers/audio_provider.dart';
import 'package:koel_player/ui/widgets/app_bar.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/song_list_buttons.dart';
import 'package:koel_player/ui/widgets/song_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:provider/provider.dart';

class QueueScreen extends StatelessWidget {
  static const routeName = '/queue';

  const QueueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AudioProvider>(
        builder: (_, provider, __) {
          if (kDebugMode) {
            print('called');
          }
          return CustomScrollView(
            slivers: <Widget>[
              AppBar(
                headingText: 'Current Queue',
                coverImage: CoverImageStack(songs: provider.queuedSongs),
                actions: <Widget>[
                  if (provider.queuedSongs.isNotEmpty)
                    TextButton(
                      onPressed: () => provider.clearQueue(),
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              if (provider.queuedSongs.isEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: const <Widget>[
                      SizedBox(height: 128),
                      Center(
                        child: Text(
                          'No songs queued.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SliverReorderableList(
                  itemCount: provider.queuedSongs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) =>
                          provider.removeFromQueue(
                        song: provider.queuedSongs[index],
                      ),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(CupertinoIcons.delete_simple),
                        ),
                      ),
                      key: ValueKey(provider.queuedSongs[index]),
                      child: SongRow(
                        index: index,
                        key: ValueKey(provider.queuedSongs[index]),
                        song: provider.queuedSongs[index],
                        listContext: SongListContext.queue,
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) =>
                      provider.reorderQueue(oldIndex, newIndex),
                ),
              const BottomSpace(),
            ],
          );
        },
      ),
    );
  }
}
