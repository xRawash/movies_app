import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/features/torrent_player_screen/torrent_player_controller.dart';

class TorrentPlayerScreen extends StatefulWidget {
  const TorrentPlayerScreen({
    super.key,
    required this.magnetLink,
    required this.torrentId,
    required this.movie
  });
  final String torrentId;
  final String magnetLink;
  final Movie movie;

  @override
  State<TorrentPlayerScreen> createState() => _TorrentPlayerScreenState();
}

class _TorrentPlayerScreenState extends State<TorrentPlayerScreen> {
  late final TorrentPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TorrentPlayerController(
      magnetLink: widget.magnetLink,
      torrentId: widget.torrentId,
      movie: widget.movie
    )..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                          "Go Back",
                          style: TextStyle(color: ColorsManager.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (_controller.isReady) {
              return Chewie(controller: _controller.chewieController!);
            }
            return _LoadingView(
              bufferPct: _controller.bufferPct,
              progress: _controller.progress,
            );
          },
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  final double progress;
  final int bufferPct;
  const _LoadingView({required this.bufferPct, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 24),
        Text(
          "Torrent Progress: ${(progress * 100).toStringAsFixed(1)}%",
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Buffered ahead: $bufferPct%",
          style: TextStyle(color: ColorsManager.grey),
        ),
      ],
    );
  }
}
