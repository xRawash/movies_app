import 'package:movies_app/api/subdl_api/subdl_api_service.dart';
import 'package:movies_app/api/subdl_response/subdl_subtitle.dart';
import 'package:movies_app/repos/subtitle_repo/subtitle_repo.dart';
class SubtitleRepoImpl implements SubtitleRepo {
  SubtitleRepoImpl({required this._apiService});

  final SubdlApiService _apiService;

  @override
  Future<List<SubdlSubtitle>> searchSubtitles({
    required String title,
    required int year,
    String? imdbId,
    required String language,
  }) {
    return _apiService.searchSubtitles(
      title: title,
      year: year,
      imdbId: imdbId,
      language: language,
    );
  }

  @override
  Future<String> downloadSubtitle(
      SubdlSubtitle subtitle,
      ) {
    return _apiService.downloadSubtitle(subtitle);
  }
}