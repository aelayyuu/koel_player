import 'package:koel_player/models/artist.dart';
import 'package:koel_player/providers/artist_provider.dart';
import 'package:koel_player/router.dart';
import 'package:koel_player/ui/widgets/artist_thumbnail.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatefulWidget {
  static const routeName = '/artists';
  final AppRouter router;

  const ArtistsScreen({
    Key? key,
    this.router = const AppRouter(),
  }) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  late ArtistProvider artistProvider;
  late List<Artist> _artists = [];

  @override
  void initState() {
    super.initState();
    artistProvider = context.read();
    setState(() => _artists = artistProvider.artists);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: Colors.white,
        ),
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              backgroundColor: Colors.black,
              largeTitle: LargeTitle(text: 'Artists'),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Artist artist = _artists[index];
                  return InkWell(
                    onTap: () => widget.router.gotoArtistDetailsScreen(
                      context,
                      artist: artist,
                    ),
                    child: ListTile(
                      shape: Border(bottom: Divider.createBorderSide(context)),
                      leading: ArtistThumbnail(artist: artist, asHero: true),
                      title: Text(artist.name, overflow: TextOverflow.ellipsis),
                    ),
                  );
                },
                childCount: _artists.length,
              ),
            ),
            const BottomSpace(),
          ],
        ),
      ),
    );
  }
}
