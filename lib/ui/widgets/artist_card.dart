import 'package:koel_player/models/artist.dart';
import 'package:koel_player/router.dart';
import 'package:koel_player/ui/widgets/artist_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatefulWidget {
  final Artist artist;
  final AppRouter router;

  const ArtistCard({
    Key? key,
    required this.artist,
    this.router = const AppRouter(),
  }) : super(key: key);

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  double _opacity = 1.0;
  final double _cardWidth = 144.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _opacity = 0.4),
      onTapUp: (_) => setState(() => _opacity = 1.0),
      onTapCancel: () => setState(() => _opacity = 1.0),
      onTap: () => widget.router.gotoArtistDetailsScreen(
        context,
        artist: widget.artist,
      ),
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _opacity,
        child: Column(
          children: <Widget>[
            ArtistThumbnail(
              artist: widget.artist,
              size: ThumbnailSize.md,
              asHero: true,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: _cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.artist.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
