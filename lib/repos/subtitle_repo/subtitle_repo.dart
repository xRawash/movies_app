import 'package:movies_app/api/subdl_response/subdl_subtitle.dart';

abstract class SubtitleRepo {
  Future<List<SubdlSubtitle>> searchSubtitles({
    required String title,
    required int year,
    String? imdbId,
    required String language,
  });

  Future<String> downloadSubtitle(
      SubdlSubtitle subtitle,
      );
}