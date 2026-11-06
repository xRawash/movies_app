import 'package:flutter/foundation.dart';
import 'package:movies_app/api/subdl_response/subdl_subtitle.dart';

import 'package:movies_app/repos/subtitle_repo/subtitle_repo.dart';

class SubtitleViewModel extends ChangeNotifier {
  SubtitleViewModel({required this._repository});

  final SubtitleRepo _repository;

  bool isLoading = false;
  bool isDownloading = false;

  String? errorMessage;
  String? selectedSubtitlePath;

  SubdlSubtitle? selectedSubtitle;

  List<SubdlSubtitle> subtitles = [];

  int _searchRequestId = 0;

  Future<void> searchSubtitles({
    required String title,
    required int year,
    String? imdbId,
    required String language,
  }) async {
    final requestId = ++_searchRequestId;

    isLoading = true;
    errorMessage = null;
    subtitles = [];

    notifyListeners();

    try {
      final results = await _repository.searchSubtitles(
        title: title,
        year: year,
        imdbId: imdbId,
        language: language,
      );

      if (requestId != _searchRequestId) return;

      subtitles = results;
    } catch (e) {
      if (requestId != _searchRequestId) return;

      errorMessage = e.toString();
    } finally {
      if (requestId == _searchRequestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> downloadSubtitle(
      SubdlSubtitle subtitle,
      ) async {
    if (isDownloading) return false;

    isDownloading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final path = await _repository.downloadSubtitle(subtitle);

      selectedSubtitlePath = path;
      selectedSubtitle = subtitle;

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  void turnOffSubtitles() {
    selectedSubtitlePath = null;
    selectedSubtitle = null;

    notifyListeners();
  }
}