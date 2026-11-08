import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/api/subdl_api/subdl_api_service.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/features/torrent_player_screen/helpers/subtitle_helpers.dart';
import 'package:movies_app/features/torrent_player_screen/torrent_player_controller.dart';
import 'package:movies_app/features/torrent_player_screen/widgets/loading_view.dart';
import 'package:movies_app/repos/subtitle_repo/subtitle_repo_impl.dart';
import 'package:movies_app/view_models/subtitle_view_model/subtitle_view_model.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
    WakelockPlus.enable();

    _subtitleApiService = SubdlApiService();
    _subtitleViewModel = SubtitleViewModel(
      repository: SubtitleRepoImpl(apiService: _subtitleApiService),
    );

    _controller = TorrentPlayerController(
      magnetLink: widget.magnetLink,
      torrentId: widget.torrentId,
      movie: widget.movie,
      onSubtitlesPressed: () => SubtitleHelpers.showSubtitlePicker(
        context: context,
        subtitleViewModel: _subtitleViewModel,
        movie: widget.movie,
        torrentController: _controller,
      ),
    )..start();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _subtitleViewModel.dispose();
    _subtitleApiService.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
