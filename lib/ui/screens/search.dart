import 'package:koel_player/constants/colors.dart';
import 'package:koel_player/constants/dimensions.dart';
import 'package:koel_player/models/album.dart';
import 'package:koel_player/models/artist.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/search_provider.dart';
import 'package:koel_player/ui/widgets/album_card.dart';
import 'package:koel_player/ui/widgets/artist_card.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/horizontal_card_scroller.dart';
import 'package:koel_player/ui/widgets/simple_song_list.dart';
import 'package:koel_player/ui/widgets/typography.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _hasFocus = false;
  bool _initial = true;
  List<Song> _songs = [];
  List<Artist> _artists = [];
  List<Album> _albums = [];

  late SearchProvider searchProvider;
  late final TextEditingController _controller = TextEditingController(text: '');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    searchProvider = context.read();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  _search(String keywords) => EasyDebounce.debounce(
        'search',
        const Duration(microseconds: 500), // typing on a phone isn't that fast
        () async {
          if (keywords.isEmpty) return _resetSearch();
          if (keywords.length < 2) return;

          SearchResult result = await searchProvider.searchExcerpts(
            keywords: keywords,
          );

          setState(() {
            _initial = false;
            _songs = result.songs;
            _albums = result.albums;
            _artists = result.artists;
          });
        },
      );

  Widget get noResults {
    return const Padding(
      padding: EdgeInsets.only(left: AppDimensions.horizontalPadding),
      child: Text(
        'None found.',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  void _resetSearch() {
    _controller.text = '';
    setState(() => _initial = true);
  }

  Widget get searchField {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.horizontalPadding),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoSearchTextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: AppDimensions.inputBorderRadius,
              ),
              placeholder: 'Search your library',
              onChanged: _search,
              onSuffixTap: _resetSearch,
            ),
          ),
          if (_hasFocus)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () {
                  _resetSearch();
                  _focusNode.unfocus();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchField,
            if (!_initial)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.horizontalPadding,
                        ),
                        child: SimpleSongList(
                          songs: _songs,
                          bordered: true,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: AppDimensions.horizontalPadding,
                        ),
                        child: Heading5(text: 'Albums'),
                      ),
                      if (_albums.isEmpty)
                        noResults
                      else
                        HorizontalCardScroller(
                          cards:
                              _albums.map((album) => AlbumCard(album: album)),
                        ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: AppDimensions.horizontalPadding),
                        child: Heading5(text: 'Artists'),
                      ),
                      if (_artists.isEmpty)
                        noResults
                      else
                        HorizontalCardScroller(
                          cards: _artists
                              .map((artist) => ArtistCard(artist: artist)),
                        ),
                      const BottomSpace(asSliver: false),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
