
import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/l10n/app_localizations.dart';

void showResolutionDialog(BuildContext context, Movie movie) {
  final l10n = AppLocalizations.of(context)!;

  final availableTorrents = <String, dynamic>{};
  String? normalizeQuality(String? quality) {
    if (quality == null) return null;

    switch (quality.trim().toLowerCase()) {
      case '4k':
      case '2160':
      case '2160p':
        return '2160p';

      case '1080':
      case '1080p':
        return '1080p';

      case '720':
      case '720p':
        return '720p';

      default:
        return null;
    }
  }
  for (final torrent in movie.torrents ?? []) {
    final quality = normalizeQuality(torrent.quality);

    if (quality != null) {
      availableTorrents.putIfAbsent(quality, () => torrent);
    }
  }

  final resolutions = ['2160p', '1080p', '720p'];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: ColorsManager.darkGrey,
        title: Text(
          l10n.chooseResolution,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final resolution in resolutions)
              if (availableTorrents.containsKey(resolution))
                ListTile(
                  title: Text(
                    resolution == '2160p' ? '2160p (4K)' : resolution,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    final torrent = availableTorrents[resolution];
                    final hash = torrent.hash ?? '';

                    final magnetLink =
                        'magnet:?xt=urn:btih:$hash'
                        '&dn=${Uri.encodeComponent(movie.title ?? '')}'
                        '&tr=udp://tracker.opentrackr.org:1337/announce'
                        '&tr=udp://tracker.torrent.eu.org:451/announce'
                        '&tr=udp://open.stealth.si:80/announce';

                    Navigator.pop(dialogContext);

                    Navigator.pushNamed(
                      context,
                      RoutesManager.torrentPlayer,
                      arguments: {
                        'magnetLink': magnetLink,
                        'torrentId': hash.isNotEmpty ? hash : '1',
                        'movie': movie,
                      },
                    );
                  },
                ),

            if (availableTorrents.isEmpty)
              Text(
                l10n.noTorrentsAvailable,
                style: const TextStyle(color: Colors.white70),
              ),
          ],
        ),
      );
    },
  );

}
