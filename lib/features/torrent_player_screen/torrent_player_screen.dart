import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/api/subdl_api/subdl_api_service.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/utilities/srt_parser.dart';
import 'package:movies_app/features/torrent_player_screen/torrent_player_controller.dart';
import 'package:movies_app/features/torrent_player_screen/widgets/loading_view.dart';
import 'package:movies_app/features/torrent_player_screen/widgets/subtitle_picker_sheet.dart';
import 'package:movies_app/repos/subtitle_repo/subtitle_repo_impl.dart';
import 'package:movies_app/view_models/subtitle_view_model/subtitle_view_model.dart';

class TorrentPlayerScreen extends StatefulWidget {
  const TorrentPlayerScreen({
    super.key,
    required this.magnetLink,
    required this.torrentId,
    required this.movie,
  });

  final String torrentId;
  final String magnetLink;
  final Movie movie;

  @override
  State<TorrentPlayerScreen> createState() =>
      _TorrentPlayerScreenState();
}

class _TorrentPlayerScreenState
    extends State<TorrentPlayerScreen> {
  late final TorrentPlayerController _controller;

  late final SubdlApiService _subtitleApiService;
  late final SubtitleViewModel _subtitleViewModel;

  @override
  void initState() {
    super.initState();

    _controller = TorrentPlayerController(
      magnetLink: widget.magnetLink,
      torrentId: widget.torrentId,
      movie: widget.movie,
    )..start();
    _subtitleApiService = SubdlApiService();

    _subtitleViewModel = SubtitleViewModel(
      repository: SubtitleRepoImpl(apiService: _subtitleApiService)
    );
  }


  Future<void> _applySelectedSubtitle() async {
    final path = _subtitleViewModel.selectedSubtitlePath;
    final subtitle = _subtitleViewModel.selectedSubtitle;


    if (path == null || subtitle == null) {
      _controller.turnOffSubtitleTrack();
      return;
    }

    try {
      final cues = await SrtParser.parseFile(path);

      if (!mounted) return;

      // Register the track and its subtitle cues.
      _controller.addSubtitleTrack(
        id: path,
        label: subtitle.releaseName.isNotEmpty
            ? subtitle.releaseName
            : subtitle.name,
        language: subtitle.language,
        subtitles: cues,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load subtitles: $e'),
        ),
      );
    }
  }

  void _showSubtitlePicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsManager.black,
      builder: (context) {
        return SubtitlePickerSheet(
          viewModel: _subtitleViewModel,
          movie: widget.movie,
          onSelected: _applySelectedSubtitle,
        );
      },
    );
  }

  @override
  void dispose() {
    _subtitleViewModel.dispose();
    _subtitleApiService.dispose();

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Search subtitles',
            onPressed: _showSubtitlePicker,
            icon: const Icon(
              Icons.subtitles,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _controller.errorMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.yellow,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Go Back',
                          style: TextStyle(
                            color: ColorsManager.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_controller.isReady) {
              return Chewie(
                controller: _controller.chewieController!,
              );
            }

            return LoadingView();
          },
        ),
      ),
    );
  }
}