import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/utilities/srt_parser.dart';
import 'package:movies_app/features/torrent_player_screen/torrent_player_controller.dart';
import 'package:movies_app/features/torrent_player_screen/widgets/subtitle_picker_sheet.dart';
import 'package:movies_app/view_models/subtitle_view_model/subtitle_view_model.dart';

class SubtitleHelpers {
  static Future<void> applySelectedSubtitle({
    required BuildContext context,
    required SubtitleViewModel subtitleViewModel,
    required TorrentPlayerController torrentController,
  }) async {
    final path = subtitleViewModel.selectedSubtitlePath;
    final subtitle = subtitleViewModel.selectedSubtitle;

    if (path == null || subtitle == null) {
      torrentController.turnOffSubtitleTrack();
      return;
    }

    try {
      final cues = await SrtParser.parseFile(path);

      if (!context.mounted) return;

      torrentController.addSubtitleTrack(
        id: path,
        label: subtitle.releaseName.isNotEmpty
            ? subtitle.releaseName
            : subtitle.name,
        language: subtitle.language,
        subtitles: cues,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load subtitles: $e'),
        ),
      );
    }
  }

  static void showSubtitlePicker({
    required BuildContext context,
    required SubtitleViewModel subtitleViewModel,
    required Movie movie,
    required TorrentPlayerController torrentController,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsManager.black,
      builder: (sheetContext) {
        return SubtitlePickerSheet(
          viewModel: subtitleViewModel,
          movie: movie,
          onSelected: () => applySelectedSubtitle(
            context: sheetContext,
            subtitleViewModel: subtitleViewModel,
            torrentController: torrentController,
          ),
        );
      },
    );
  }
}
