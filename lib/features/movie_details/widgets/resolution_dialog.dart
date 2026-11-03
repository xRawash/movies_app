import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/l10n/app_localizations.dart';

void showResolutionDialog(BuildContext context, Movie movie) {
  var l10n = AppLocalizations.of(context)!;
  String torrentId_720p = "";
  String torrentId_1080p = "";
  String magnetLink_720p = "";
  String magnetLink_1080p = "";

  if (movie.torrents != null) {
    for (var t in movie.torrents!) {
      if (t.quality == '720p') {
        torrentId_720p = t.hash ?? '';
        magnetLink_720p =
            "magnet:?xt=urn:btih:${t.hash}&dn=${Uri.encodeComponent(movie.title ?? '')}&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce";
      } else if (t.quality == '1080p') {
        torrentId_1080p = t.hash ?? '';
        magnetLink_1080p =
            "magnet:?xt=urn:btih:${t.hash}&dn=${Uri.encodeComponent(movie.title ?? '')}&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce";
      }
    }
  }

  if (magnetLink_720p.isEmpty && movie.torrents != null && movie.torrents!.isNotEmpty) {
    final t = movie.torrents![0];
    torrentId_720p = t.hash ?? '';
    magnetLink_720p =
        "magnet:?xt=urn:btih:${t.hash}&dn=${Uri.encodeComponent(movie.title ?? '')}&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce";
  }
  if (magnetLink_1080p.isEmpty && movie.torrents != null && movie.torrents!.length > 1)
  {
    final t = movie.torrents![1];
    torrentId_1080p = t.hash ?? '';
    magnetLink_1080p =
        "magnet:?xt=urn:btih:${t.hash}&dn=${Uri.encodeComponent(movie.title ?? '')}&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce";
  } else if (magnetLink_1080p.isEmpty && magnetLink_720p.isNotEmpty) {
    magnetLink_1080p = magnetLink_720p;
    torrentId_1080p = torrentId_720p;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColorsManager.darkGrey,
        title: Text(
          l10n.chooseResolution,
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (magnetLink_720p.isNotEmpty)
              ListTile(
                title: Text("720p", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    RoutesManager.torrentPlayer,
                    arguments: {
                      'magnetLink': magnetLink_720p,
                      'torrentId': torrentId_720p.isNotEmpty
                          ? torrentId_720p
                          : '1',
                      'movie': movie,
                    },
                  );
                },
              ),
            if (magnetLink_1080p.isNotEmpty)
              ListTile(
                title: Text("1080p", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    RoutesManager.torrentPlayer,
                    arguments: {
                      'magnetLink': magnetLink_1080p,
                      'torrentId': torrentId_1080p.isNotEmpty
                          ? torrentId_1080p
                          : '1',
                      'movie': movie,
                    },
                  );
                },
              ),
            if (magnetLink_720p.isEmpty && magnetLink_1080p.isEmpty)
              Text(
                l10n.noTorrentsAvailable,
                style: TextStyle(color: Colors.white70),
              ),
          ],
        ),
      );
    },
  );
}
