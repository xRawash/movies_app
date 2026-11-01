import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:libtorrent_flutter/libtorrent_flutter.dart';
import 'package:movies_app/api/movie_detailed_response/Movie.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/prefs_manager/prefs_manager.dart';
import 'package:video_player/video_player.dart';

class TorrentPlayerController extends ChangeNotifier {
  final String torrentId;
  final String magnetLink;
  TorrentPlayerController({required this.magnetLink, required this.torrentId, required this.movie});
  final _engine = LibtorrentFlutter.instance;
  String get _resumeKey => 'resume_$torrentId';
  Movie movie;

  int? _torrentNativeId;
  StreamSubscription? _torrentSub;
  StreamSubscription? _streamSub;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _streamStarted = false;
  bool _playbackStarted = false;
  bool _disposed = false;
  double _progress = 0;
  int _bufferPct = 0;
  String? _errorMessage;

  ChewieController? get chewieController => _chewieController;
  bool get isReady => _chewieController != null;
  double get progress => _progress;
  int get bufferPct => _bufferPct;
  String? get errorMessage => _errorMessage;

  Future<void> start() async {
    try {
      final id = _engine.addMagnet(magnetLink);
      _torrentNativeId = id;

      _torrentSub = _engine.torrentUpdates.listen((torrents) {
        final t = torrents[id];
        if (t == null || _disposed) return;
        _progress = t.progress;
        notifyListeners();

        if (t.hasMetadata && !_streamStarted && _engine.getFiles(id).isNotEmpty) {
          _streamStarted = true;
          _startStream(id);
        }
      });
    } catch (e) {
      if (!_disposed) {
        _errorMessage = "Failed to load torrent. Please try again.";
        Utilities.showToast("Failed to load torrent");
        notifyListeners();
      }
    }
  }

  void _startStream(int torrentId) {
    try {
      final stream = _engine.startStream(torrentId);

      _streamSub = _engine.streamUpdates.listen((streams) {
        final s = streams[stream.id];
        if (s == null || _disposed) return;

        _bufferPct = s.bufferPct;
        notifyListeners();

        if (s.isReady && !_playbackStarted) {
          _playbackStarted = true;
          _startPlayback(s.url);
        }
      });
    } catch (e) {
      if (!_disposed) {
        _errorMessage = "Failed to stream media. Please try another quality.";
        Utilities.showToast("Failed to stream media");
        notifyListeners();
      }
    }
  }

  Future<void> _startPlayback(String url) async {
    try {
      final savedMs = PrefsManager.prefs.getInt(_resumeKey) ?? 0;

      final video = VideoPlayerController.networkUrl(Uri.parse(url));
      await video.initialize();

      if (_disposed) {
        await video.dispose();
        return;
      }

      _videoController = video;
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        startAt: savedMs > 0 ? Duration(milliseconds: savedMs) : null,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Playback error: $errorMessage",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
      notifyListeners();
    } catch (e) {
      if (!_disposed) {
        _errorMessage = "Video initialization error or unsupported format.";
        Utilities.showToast("Playback failed. Unsupported format.");
        notifyListeners();
      }
    }
  }

  void _savePosition() {
    final v = _videoController?.value;
    if (v == null || !v.isInitialized) return;

    final position = v.position.inMilliseconds;
    final nearEnd = v.duration.inMilliseconds - position < 10000;
    if (nearEnd) {
      PrefsManager.prefs.remove(_resumeKey);
      FirebaseServices.addMovieToHistory(movie);
    } else {
      PrefsManager.prefs.setInt(_resumeKey, position);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _savePosition();
    _torrentSub?.cancel();
    _streamSub?.cancel();
    _videoController?.dispose();
    _chewieController?.dispose();
    if (_torrentNativeId != null) {
      _engine.disposeTorrent(_torrentNativeId!);
    }
    super.dispose();
  }
}
